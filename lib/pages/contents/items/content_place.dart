import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';
import 'package:munch_app/pages/places/place_card.dart';

class ContentPlace extends ContentItemWidget {
  ContentPlace(CreatorContentItem item, ContentPageState state)
      : super(item, state);

  Place get place => state.places[placeId];

  String get placeId => this.item.body['placeId'];

  String get placeName => this.item.body['placeName'];

  String get imageCreditName {
    if (place == null) return null;
    if (place.images.isEmpty) return null;
    return place.images[0]?.profile?.name;
  }

  @override
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item) {
    // TODO ContentPlace
    if (place == null) {
      return Container(
          // //
          ////    <div v-else class="p-24 bg-peach100 border-5">
          ////      <h2>{{placeName}}</h2>
          ////      <div class="large m-0">This place has permanently closed or removed from Munch.</div>
          ////      <h6 class="m-0">Know this place? <a :href="`/places/suggest?placeId=${placeId}`" target="_blank">Suggest an edit.</a></h6>
          ////    </div>
          );
    }

    // //    <div class="ContentCredit flex-end absolute w-100" v-if="selectedCreditName">
    ////      <div class="small-bold lh-1">
    ////        Image by: {{selectedCreditName}}
    ////      </div>
    ////    </div>

    return Column(
      children: <Widget>[
        PlaceCard(
          place: place,
        )
      ],
    );
  }
}

// <template>
//  <div class="ContentPlace mt-32 mb-24 relative">
//    <nuxt-link :to="`/places/${placeId}`" v-if="selectedImage">
//      <div class="aspect r-5-3 border-4 overflow-hidden">
//        <image-sizes :sizes="selectedImage.sizes" :alt="place.name" :height="1000" :width="1000">
//
//          <div class="wh-100 hover-opacity">
//            <div class="ImageGallery flex-align-end">
//              <div class="Item hover-pointer elevation-1" v-for="(gi, index) in galleryImages" :key="index"
//                   @click.stop.prevent="selectedIndex = index">
//                <div class="aspect r-1-1 border-4 overflow-hidden">
//                  <image-sizes :sizes="gi.sizes" width="200" height="200"/>
//                </div>
//              </div>
//            </div>
//          </div>
//        </image-sizes>
//      </div>
//    </nuxt-link>
//

//
//    <div v-if="place" class="ContentInfo mt-24 relative">
//      <nuxt-link :to="`/places/${placeId}`">
//        <h2 class="m-0">{{place.name}}</h2>
//      </nuxt-link>
//      <place-status class="mt-16" :place="place"/>
//      <nuxt-link :to="`/places/${placeId}`">
//        <div class="subtext mtb-4"><b>{{location.neighbourhood}}</b> <b>·</b> {{location.address}}</div>
//      </nuxt-link>
//
//      <div class="Tags flex-wrap mt-16 overflow-hidden">
//        <div class="Tag text weight-600 border-3 mr-8 mb-8 flex-no-shrink flex-center" v-for="tag in tags"
//             :key="tag.tagId" :class="{
//                 'Price bg-peach100': tag.type === 'price',
//                 'bg-whisper100 b-a75': tag.type !== 'price'}"
//        >
//          <span>{{tag.name}}</span>
//        </div>
//      </div>
//    </div>

//  </div>
//</template>
