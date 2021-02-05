class Session {
  final String name;
  final String description;
  final String creatorId;
  final List<String> readers;
  final String chapters;
  final int noOfChaptersTaken;
  final int noOfChaptersFinished;
  final int order;

  Session(
      {this.name,
      this.description,
      this.creatorId,
      this.readers,
      this.chapters,
      this.noOfChaptersTaken,
      this.noOfChaptersFinished,
      this.order});
}
