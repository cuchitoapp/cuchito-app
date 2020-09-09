import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuchitoapp/models/user.dart';
import 'package:cuchitoapp/registro/login.dart';
import 'package:cuchitoapp/screens/EditProfilePage.dart';
import 'package:cuchitoapp/widgets/HeaderWidget.dart';
import 'package:cuchitoapp/widgets/PostTileWidget.dart';
import 'package:cuchitoapp/widgets/PostWidget.dart';
import 'package:cuchitoapp/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = "grid";
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;

  void initState() {
    getAllProfilePosts();
    getAllFollowers();
    getAllFollowings();
    checkIfAlreadyFollowing();
  }

  getAllFollowings() async {
    QuerySnapshot querySnapshot = await followingRefrence
        .document(widget.userProfileId)
        .collection("userFollowing")
        .getDocuments();
    setState(() {
      countTotalFollowings = querySnapshot.documents.length;
    });
  }

  checkIfAlreadyFollowing() async {
    DocumentSnapshot documentSnapshot = await followersRefrence
        .document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .get();

    setState(() {
      following = documentSnapshot.exists;
    });
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await followersRefrence
        .document(widget.userProfileId)
        .collection("userFollowers")
        .getDocuments();
    setState(() {
      countTotalFollowers = querySnapshot.documents.length;
    });
  }

  createProfileTopView() {
    return FutureBuilder(
      future: usersReference.document(widget.userProfileId).get(),
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(datasnapshot.data);
        return Padding(
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            createColums("Posts", countPost),
                            createColums("followers", countTotalFollowers),
                            createColums("following", countTotalFollowings),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [createButton()],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  user.username,
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  user.profileName,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 3.0),
                child: Text(
                  user.bio,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Column createColums(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return createBottonTitleAndFunction(
        title: "Editar perfil",
        performFunction: editUserProfile,
      );
    } else if (following) {
      return createBottonTitleAndFunction(
        title: "Dejar de seguir",
        performFunction: controlUnfollowUser,
      );
    } else if (!following) {
      return createBottonTitleAndFunction(
        title: "Seguir",
        performFunction: controlFollowUser,
      );
    }
  }

  controlUnfollowUser() {
    setState(() {
      following = false;
    });
    followersRefrence
        .document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    followingRefrence
        .document(currentOnlineUserId)
        .collection("userFollowing")
        .document(widget.userProfileId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    activityFeedReference
        .document(widget.userProfileId)
        .collection("feedItems")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  controlFollowUser() {
    setState(() {
      following = true;
    });

    followersRefrence
        .document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .setData({});

    followingRefrence
        .document(currentOnlineUserId)
        .collection("userFollowing")
        .document(widget.userProfileId)
        .setData({});
    activityFeedReference
        .document(widget.userProfileId)
        .collection("feedItems")
        .document(currentOnlineUserId)
        .setData({
      "type": "follow",
      "ownerId": widget.userProfileId,
      "username": currentUser.username,
      "timestamp": DateTime.now(),
      "userProfileImg": currentUser.url,
      "userId": currentOnlineUserId,
    });
  }

  createBottonTitleAndFunction({String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 204.0,
          height: 26.0,
          child: Text(
            title,
            style: TextStyle(
                color: following ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: following ? Colors.black : Colors.blue,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6.0)),
        ),
      ),
    );
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        srtTittle: "Profile",
      ),
      body: ListView(
        children: [
          createProfileTopView(),
          Divider(),
          createListAndGridPostOrientation(),
          Divider(
            height: 0.0,
          ),
          displayProfilePost(),
        ],
      ),
    );
  }

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 150.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0),
              child: Text(
                "No existen publicaciones",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    } else if (postOrientation == "list") {
      return Column(
        children: postsList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await postsReference
        .document(widget.userProfileId)
        .collection("usersPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () => setOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == "grid"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == "list"
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
