class Session {
  final String name;
  final String description;
  final String creatorId;
  final List<String> readers;
  final String chapters;

  Session(
      {this.name,
      this.description,
      this.creatorId,
      this.readers,
      this.chapters});
}
