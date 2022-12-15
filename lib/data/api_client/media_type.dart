enum ApiClientMediaType { movie, tv }

extension MediaTypeAsString on ApiClientMediaType {
  String asString() {
    switch (this) {
      case ApiClientMediaType.movie:
        return 'movie';
      case ApiClientMediaType.tv:
        return 'tv';
    }
  }
}