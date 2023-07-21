enum ContentTypeEnum {
  applicationJson,
  multipartFormData,
  textHtml,
  urlEncoded
}

extension ContentTypeEnumExtension on ContentTypeEnum {
  Map<String, String> get value {
    switch (this) {
      case ContentTypeEnum.applicationJson:
        return {'Content-Type': 'application/json'};
      case ContentTypeEnum.multipartFormData:
        return {'Content-Type': 'multipart/form-data; boundary=something'};
      case ContentTypeEnum.textHtml:
        return {'Content-Type': 'text/html; charset=UTF-8'};
      case ContentTypeEnum.urlEncoded:
        return {'Content-Type': 'application/x-www-form-urlencoded'};
    }
  }
}
