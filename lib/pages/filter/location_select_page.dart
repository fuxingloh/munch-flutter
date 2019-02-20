import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/location.dart';
import 'package:munch_app/api/structured_exception.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/location_select_cell.dart';
import 'package:munch_app/pages/filter/location_select_save_page.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:munch_app/utils/munch_location.dart';
import 'package:rxdart/rxdart.dart';

class SearchLocationPage extends StatefulWidget {
  @override
  SearchLocationPageState createState() {
    return new SearchLocationPageState();
  }

  static Future<NamedLocation> push(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => SearchLocationPage(),
        settings: const RouteSettings(name: '/search/locations'),
      ),
    );
  }
}

class SearchLocationPageState extends State<SearchLocationPage> {
  final SearchLocationManager _manager = SearchLocationManager();
  PublishSubject<String> _onTextChanged;

  List<_Item> items = [];

  @override
  void initState() {
    super.initState();

    _manager.stream().listen((items) {
      setState(() => this.items = items);
    });

    _onTextChanged = PublishSubject<String>();
    _onTextChanged.distinct().debounce(const Duration(milliseconds: 300)).listen((text) {
      _manager.update(text);
    });
  }

  @override
  void dispose() {
    _onTextChanged.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: SearchLocationTextBar(
          onChanged: (text) => _onTextChanged.add(text),
        ),
      ),
      body: NotificationListener(
        onNotification: (t) {
          if (t is UserScrollNotification) {
             FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          itemBuilder: (_, i) {
            final item = items[i];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: buildItem(item),
              onTap: () => onItem(item),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget buildItem(_Item item) {
    if (item is _ItemHeader) {
      return SearchLocationHeaderCell(title: item.name);
    } else if (item is _ItemLocation) {
      Widget buildSaved(IconData left) {
        return SearchLocationIconTextCell(
          left: left,
          text: item.name,
          right: MunchIcons.location_cancel,
          rightPressed: () {
            MunchDialog.showConfirm(
              context,
              title: "Removed Saved Location",
              content: "${item.name} will be permanently removed from your saved locations. Do you want to continue?",
              onPressed: () {
                MunchDialog.showProgress(context);

                Authentication.instance.isAuthenticated().then((authenticated) {
                  if (authenticated) {
                    MunchApi.instance.delete('/users/locations/${item.sortId}').whenComplete(() {
                      Navigator.pop(context);
                    }).then((_) {
                      _manager.refreshHistory();
                    }).catchError((error) {
                      MunchDialog.showError(context, error);
                    });
                  }
                });
              },
            );
          },
        );
      }

      switch (item.type) {
        case _ItemLocationType.loading:
          return SearchLocationLoadingCell();

        case _ItemLocationType.current:
          return SearchLocationIconTextCell(left: MunchIcons.location_nearby, text: "Use current location");

        case _ItemLocationType.home:
          return buildSaved(MunchIcons.location_home);
        case _ItemLocationType.work:
          return buildSaved(MunchIcons.location_work);
        case _ItemLocationType.saved:
          return buildSaved(MunchIcons.location_bookmark_filled);

        case _ItemLocationType.recent:
          return SearchLocationIconTextCell(
            left: MunchIcons.location_recent,
            text: item.name,
            right: MunchIcons.location_bookmark,
            rightPressed: () {
              var location = UserLocation(
                type: UserLocationType.saved,
                input: UserLocationInput.history,
                name: item.name,
                latLng: item.latLng,
              );
              SearchLocationSavePage.push(context, location).then((_) {
                _manager.refreshHistory();
              });
            },
          );

        case _ItemLocationType.search:
          return SearchLocationTextCell(text: item.name);
      }
    }

    return null;
  }

  void pop(UserLocation location, {@required bool save}) {
    // Save User location if they are authenticated
    if (save) {
      Authentication.instance.isAuthenticated().then((authenticated) {
        if (authenticated) {
          MunchApi.instance.post('/users/locations', body: location).catchError((error) {
            print(error);
          });
        }
      });
    }

    Navigator.of(context).pop(NamedLocation(
      name: location.name,
      latLng: location.latLng,
    ));
  }

  void onItem(_Item item) {
    if (item is _ItemLocation) {
      if (item.type == _ItemLocationType.loading) return;
      if (item.type == _ItemLocationType.current) {
        MunchDialog.showProgress(context);

        MunchLocation.instance.request(force: true, permission: true).then((latLng) {
          return MunchApi.instance.post('/locations/current', body: {"latLng": latLng}).then((res) {
            return NamedLocation.fromJson(res.data);
          });
        }).whenComplete(() {
          Navigator.pop(context);
        }).then((loc) {
          pop(
            UserLocation(
              type: UserLocationType.recent,
              input: UserLocationInput.current,
              name: loc.name,
              latLng: loc.latLng,
            ),
            save: true,
          );
        }).catchError((error) {
          if (error is StructuredException) {
            if (error.code == 404) {
              pop(
                UserLocation(
                  type: UserLocationType.recent,
                  input: UserLocationInput.current,
                  name: "Current Location",
                  latLng: MunchLocation.instance.lastLatLng,
                ),
                save: false,
              );
              return;
            }
          }

          MunchDialog.showError(context, error);
        });
        return;
      }

      pop(createLocation(item), save: true);
    }
  }

  UserLocation createLocation(_ItemLocation item, {UserLocationType type = UserLocationType.recent}) {
    UserLocationInput input;
    if (item.type == _ItemLocationType.current) {
      input = UserLocationInput.current;
    } else if (item.type == _ItemLocationType.search) {
      input = UserLocationInput.searched;
    } else {
      input = UserLocationInput.history;
    }

    return UserLocation(
      type: type,
      input: input,
      name: item.name,
      latLng: item.latLng,
    );
  }
}

class SearchLocationTextBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  SearchLocationTextBar({this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      autocorrect: false,
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Search here",
        hintStyle: const TextStyle(
          fontSize: 19,
          color: MunchColors.black75,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: const TextStyle(
        fontSize: 19,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

abstract class _Item {}

class _ItemHeader implements _Item {
  String name;

  _ItemHeader({
    this.name,
  });
}

class _ItemLocation implements _Item {
  _ItemLocationType type;
  String name;
  String latLng;
  String sortId;

  _ItemLocation({
    this.type,
    this.name,
    this.latLng,
    this.sortId,
  });
}

enum _ItemLocationType { loading, current, home, work, saved, recent, search }

class SearchLocationManager {
  String text = "";
  List<UserLocation> users;
  List<NamedLocation> searched;

  StreamController<List<_Item>> _controller;

  Stream<List<_Item>> stream() {
    _controller = StreamController<List<_Item>>();
    dispatch();

    refreshHistory();
    return _controller.stream;
  }

  void refreshHistory() {
    Authentication.instance.isAuthenticated().then((authenticated) {
      if (authenticated) {
        MunchApi.instance
            .get('/users/locations?size=40')
            .then((res) => UserLocation.fromJsonList(res.data))
            .then((list) {
          users = list;
          dispatch();
        });
      } else {
        users = [];
        dispatch();
      }
    });
  }

  void dispose() {
    _controller.close();
  }

  void update(String text) {
    this.text = text;
    this.searched = null;

    dispatch();
    if (text.length < 2) return;

    // Search Data
    MunchApi.instance.post('/locations/search', body: {'text': text.toLowerCase()}).then((res) {
      return NamedLocation.fromJsonList(res.data);
    }).then((locations) {
      this.searched = locations;
      dispatch();
    });
  }

  void dispatch() {
    _controller.add(collect());
  }

  List<_Item> collect() {
    if (text.length > 1) {
      if (searched == null) {
        return [_ItemLocation(type: _ItemLocationType.loading)];
      }

      return searched.map((loc) {
        return _ItemLocation(
          type: _ItemLocationType.search,
          name: loc.name,
          latLng: loc.latLng,
        );
      }).toList(growable: false);
    } else if (text.length > 0) {
      return [];
    } else {
      List<_Item> items = [];
      items.add(_ItemLocation(type: _ItemLocationType.current));
      if (users == null) return [_ItemLocation(type: _ItemLocationType.loading)];

      Set<String> latLngs = Set<String>();
      List<_ItemLocation> saved = [];
      List<_ItemLocation> recent = [];

      users.forEach((loc) {
        if (latLngs.contains(loc.latLng)) return;

        _ItemLocation newSaved(_ItemLocationType type) {
          return _ItemLocation(type: type, name: loc.name, latLng: loc.latLng, sortId: loc.sortId);
        }

        switch (loc.type) {
          case UserLocationType.home:
            saved.add(newSaved(_ItemLocationType.home));
            break;
          case UserLocationType.work:
            saved.add(newSaved(_ItemLocationType.work));
            break;
          case UserLocationType.saved:
            saved.add(newSaved(_ItemLocationType.saved));
            break;
          case UserLocationType.recent:
            recent.add(newSaved(_ItemLocationType.recent));
            break;
        }

        latLngs.add(loc.latLng);
      });

      if (saved.isNotEmpty) {
        items.add(_ItemHeader(name: "Saved Locations"));
        items.addAll(saved);
      }

      if (recent.isNotEmpty) {
        items.add(_ItemHeader(name: "Recent Searches"));
        items.addAll(recent);
      }
      return items;
    }
  }
}
