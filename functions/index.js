
const { firestore } = require("firebase-admin");
const { config, firebaseConfig } = require("firebase-functions");
const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

exports.likedPost = functions.https.onCall((data, context) => {
  const postID = data.postID;
  const posterUID = data.posterUID;
  const liked = data.isLiked;
  const likerUID = data.likerUID;
  
  console.log("called")
  const postRef = db.collection("Users").doc(posterUID).collection("Posts").doc(postID);

  if(liked === true) 
  {
     postRef.update({likes: firestore.FieldValue.increment(1.0)})
  }else{
    postRef.update({likes: firestore.FieldValue.increment(-1.0)})
  }
  const uploadRef = db.collection("Users").doc(posterUID).collection("Posts").doc(postID).collection("Likes").doc(likerUID);
  const upload = {
   "likerUID":likerUID,
  };
  uploadRef.set(upload);
});

exports.commentedOnPost = functions.https.onCall((data, context) => {
  const postID = data.postID;
  const posterUID = data.posterUID;
  const commentText = data.commentText;
  const commenterUID = data.commenterUID;
  
  const postRef = db.collection("Users").doc(posterUID).collection("Posts").doc(postID).collection("Comments").doc();

  const upload = {
    "commentText":commentText,
    "posterUID":posterUID,
    "postID":postID,
    "commenterUID":commenterUID,
  };
  postRef.set(upload);

});




