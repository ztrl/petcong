class CardProfileModel {
  late int memberId;
  late int age;
  late String nickname;
  late String gender;
  late String petName;
  late String petGender;
  late int petAge;
  late String? instagramId;
  late String? kakaoId;
  String? description;
  List<String>? pictureUrls;

  CardProfileModel(
      {required this.memberId,
      required this.age,
      required this.nickname,
      required this.gender,
      required this.petName,
      required this.petGender,
      required this.petAge,
      this.instagramId,
      this.kakaoId,
      this.description,
      this.pictureUrls});

  CardProfileModel.fromJson(Map<String, dynamic> map) {
    memberId = map['memberId'];
    age = map['age'];
    nickname = map['nickname'];
    gender = map['gender'];
    petName = map['petName'];
    petGender = map['petGender'];
    petAge = map['petAge'];
    instagramId = map['instagramId'];
    kakaoId = map['kakaoId'];
    description = description != null ? map['description'] : '';
    pictureUrls = pictureUrls != null ? map['pictureImageUrls'] : [];
  }

  List<Object?> get props => [
        memberId,
        age,
        nickname,
        gender,
        petName,
        petGender,
        petAge,
        instagramId,
        kakaoId,
        description,
        pictureUrls
      ];
}
