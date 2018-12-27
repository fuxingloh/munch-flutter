// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) {
  return PlaceData(
      json['place'] == null
          ? null
          : Place.fromJson(json['place'] as Map<String, dynamic>),
      (json['awards'] as List)
          ?.map((e) => e == null
              ? null
              : UserPlaceCollectionItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['articles'] as List)
          ?.map((e) =>
              e == null ? null : Article.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['images'] as List)
          ?.map((e) =>
              e == null ? null : PlaceImage.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PlaceDataToJson(PlaceData instance) => <String, dynamic>{
      'place': instance.place,
      'awards': instance.awards,
      'articles': instance.articles,
      'images': instance.images
    };

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
      json['articleId'] as String,
      json['sort'] as String,
      json['domainId'] as String,
      json['domain'] == null
          ? null
          : ArticleDomain.fromJson(json['domain'] as Map<String, dynamic>),
      json['url'] as String,
      json['title'] as String,
      json['description'] as String,
      json['thumbnail'] == null
          ? null
          : Image.fromJson(json['thumbnail'] as Map<String, dynamic>),
      json['createdMillis'] as int);
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'articleId': instance.articleId,
      'sort': instance.sort,
      'domainId': instance.domainId,
      'domain': instance.domain,
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'createdMillis': instance.createdMillis
    };

ArticleDomain _$ArticleDomainFromJson(Map<String, dynamic> json) {
  return ArticleDomain(json['name'] as String, json['url'] as String);
}

Map<String, dynamic> _$ArticleDomainToJson(ArticleDomain instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};

PlaceImage _$PlaceImageFromJson(Map<String, dynamic> json) {
  return PlaceImage(
      json['imageId'] as String,
      json['sort'] as String,
      (json['sizes'] as List)
          ?.map((e) =>
              e == null ? null : ImageSize.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['title'] as String,
      json['caption'] as String,
      json['article'] == null
          ? null
          : Article.fromJson(json['article'] as Map<String, dynamic>),
      json['instagram'] == null
          ? null
          : Instagram.fromJson(json['instagram'] as Map<String, dynamic>),
      json['createdMillis'] as int);
}

Map<String, dynamic> _$PlaceImageToJson(PlaceImage instance) =>
    <String, dynamic>{
      'imageId': instance.imageId,
      'sort': instance.sort,
      'sizes': instance.sizes,
      'title': instance.title,
      'caption': instance.caption,
      'article': instance.article,
      'instagram': instance.instagram,
      'createdMillis': instance.createdMillis
    };

Instagram _$InstagramFromJson(Map<String, dynamic> json) {
  return Instagram(json['accountId'] as String, json['mediaId'] as String,
      json['link'] as String, json['username'] as String);
}

Map<String, dynamic> _$InstagramToJson(Instagram instance) => <String, dynamic>{
      'accountId': instance.accountId,
      'mediaId': instance.mediaId,
      'link': instance.link,
      'username': instance.username
    };
