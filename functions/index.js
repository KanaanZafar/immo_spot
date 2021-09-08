const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.deleteUser = functions.database.ref('/users/{uid}').onDelete((snap, ctx) => {
    return admin.auth().deleteUser(snap.key)
          .then(() => console.log('Deleted user with ID:' + snap.key))
          .catch((error) => console.error('There was an error while deleting user:', error));
 });
// exports.deleteAuthUser = functions.database.ref('users/{userId}').onDelete((snapshot, context) => {

//     admin.auth().deleteUser(snapshot.id).then(function() {
//         console.log("Successfully deleted user");
//                 return '';
//     }).catch(function(error) {
//         console.log("Error deleting user:", error);
//     });


//     return true;
// });