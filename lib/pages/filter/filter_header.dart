import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

class FilterAppBar extends PreferredSize {
  FilterAppBar(this._manager);

  final FilterManager _manager;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation1,
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(left: 18, right: 18),
              icon: Icon(Icons.arrow_back, color: MunchColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(child: _FilterAppBarTags(manager: _manager)),
            IconButton(
              padding: const EdgeInsets.only(left: 18, right: 23),
              icon: Icon(MunchIcons.search_header_reset,
                  color: MunchColors.black),
              onPressed: () => _manager.reset(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 80);
}

class _FilterAppBarTags extends StatelessWidget {
  const _FilterAppBarTags({Key key, this.manager}) : super(key: key);

  final FilterManager manager;

  @override
  Widget build(BuildContext context) {
    const MunchTagStyle _style = MunchTagStyle(
      backgroundColor: MunchColors.whisper100,
      padding: EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: MunchColors.black75,
      ),
    );


    List<FilterToken> tokens = FilterToken.getTokens(manager.searchQuery);
    List<MunchTagData> list = FilterToken.getTextPart(tokens).map((text) {
      return MunchTagData(text, style: _style);
    }).toList(growable: false);

    return MunchTagView(tags: list);
  }
}

// class FilterHeaderView: UIView {
//    let tagView = FilterHeaderTagView()
//    let resetButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Search-Header-Reset"), for: .normal)
//        button.tintColor = .black
//        return button
//    }()
//    let closeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Search-Header-Close"), for: .normal)
//        button.tintColor = .black
//        button.imageEdgeInsets.right = 24
//        button.contentHorizontalAlignment = .right
//        return button
//    }()
//
//    var manager: FilterManager!
//    var searchQuery: SearchQuery? {
//        didSet {
//            self.tagView.query = self.searchQuery
//        }
//    }
//
//    override init(frame: CGRect = .zero) {
//        super.init(frame: frame)
//        self.backgroundColor = .white
//
//        self.addSubview(tagView)
//        self.addSubview(resetButton)
//        self.addSubview(closeButton)
//
//        tagView.snp.makeConstraints { maker in
//            maker.top.equalTo(self.safeArea.top).inset(10)
//            maker.bottom.equalTo(self).inset(10)
//            maker.height.equalTo(32)
//
//            maker.left.equalTo(self).inset(24)
//            maker.right.equalTo(resetButton.snp.right).inset(-16)
//        }
//
//        resetButton.snp.makeConstraints { maker in
//            maker.top.bottom.equalTo(tagView)
//            maker.right.equalTo(closeButton.snp.left).inset(-8)
//            maker.width.equalTo(24)
//        }
//
//        closeButton.snp.makeConstraints { maker in
//            maker.top.bottom.equalTo(tagView)
//
//            maker.right.equalTo(self)
//            maker.width.equalTo(24 + 24)
//        }
//    }
//
//    var tags: [FilterToken] = []
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.shadow(vertical: 2)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class FilterHeaderTagView: UIView {
//    var first = TagView()
//    var second = TagView()
//    var third = TagView()
//
//    var tags = [FilterToken]()
//    var query: SearchQuery? {
//        didSet {
//            if let query = self.query {
//                let tags = FilterToken.getTokens(query: query)
//                self.first.text = tags.get(0)?.text
//                self.second.text = tags.get(1)?.text
//
//                let count = tags.count - 2
//                self.third.text = count > 0 ? "+\(count)" : nil
//            } else {
//                self.first.text = nil
//                self.second.text = nil
//                self.third.text = nil
//            }
//        }
//    }
//
//    override init(frame: CGRect = .zero) {
//        super.init(frame: frame)
//        self.addSubview(first)
//        self.addSubview(second)
//        self.addSubview(third)
//
//        first.snp.makeConstraints { maker in
//            maker.left.equalTo(self)
//            maker.top.bottom.equalTo(self)
//        }
//
//        second.snp.makeConstraints { maker in
//            maker.left.equalTo(first.snp.right).inset(-10)
//            maker.top.bottom.equalTo(self)
//        }
//
//        third.snp.makeConstraints { maker in
//            maker.left.equalTo(second.snp.right).inset(-10)
//            maker.top.bottom.equalTo(self)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    class TagView: UIButton {
//        private let textLabel = UILabel()
//                .with(size: 14, weight: .medium, color: .ba80)
//
//        var text: String? {
//            set(value) {
//                if let value = value {
//                    self.isHidden = false
//                    self.textLabel.text = value
//                } else {
//                    self.isHidden = true
//                }
//            }
//            get {
//                return self.textLabel.text
//            }
//        }
//
//        override init(frame: CGRect = .zero) {
//            super.init(frame: frame)
//            self.addSubview(textLabel)
//
//            self.backgroundColor = .whisper100
//            self.layer.cornerRadius = 4
//
//            self.textLabel.snp.makeConstraints { maker in
//                maker.left.right.equalTo(self).inset(11)
//                maker.top.bottom.equalTo(self)
//            }
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
//}
