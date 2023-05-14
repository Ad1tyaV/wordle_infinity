class InviteCode {
  final String word;
  final DateTime dateTime;

  InviteCode(this.word, this.dateTime);

  factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(json['word'], DateTime.parse(json['dateTime']));
  }
}
