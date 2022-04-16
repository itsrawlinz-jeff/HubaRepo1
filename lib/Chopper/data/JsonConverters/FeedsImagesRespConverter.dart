import 'package:chopper/chopper.dart';
import 'package:dating_app/Serializers/Chopper/FeedsImagesRespSerializer.dart';
import 'package:built_collection/built_collection.dart';

class FeedsImagesRespConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    return super.convertRequest(
      request.replace(
        body: feedsImagesResp_serializers.serializeWith(
          feedsImagesResp_serializers.serializerForType(request.body.runtimeType),
          request.body,
        ),
      ),
    );
  }

  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType>(
      Response response,
      ) {
    final Response dynamicResponse = super.convertResponse(response);
    final BodyType customBody =
    _convertToCustomObject<SingleItemType>(dynamicResponse.body);
    return dynamicResponse.replace<BodyType>(body: customBody);
  }

  dynamic _convertToCustomObject<SingleItemType>(dynamic element) {
    if (element is SingleItemType) return element;

    if (element is List)
      return _deserializeListOf<SingleItemType>(element);
    else
      return _deserialize<SingleItemType>(element);
  }

  BuiltList<SingleItemType> _deserializeListOf<SingleItemType>(
      List dynamicList,
      ) {
    return BuiltList<SingleItemType>(
      dynamicList.map((element) => _deserialize<SingleItemType>(element)),
    );
  }

  SingleItemType _deserialize<SingleItemType>(
      Map<String, dynamic> value,
      ) {
    return feedsImagesResp_serializers.deserializeWith(
      feedsImagesResp_serializers.serializerForType(SingleItemType),
      value,
    );
  }
}
