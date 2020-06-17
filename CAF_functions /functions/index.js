const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloPapu = functions.https.onRequest((request, response) => {
 response.send("Hello fPaPu!");

 var payload = {
   notification: {
     title: "Nuevo pedido de Oración",
     body: "Estamos orando en comunidad"
   }
 }


 return admin.database().ref('/ChurchsFollowers/' + '/37E98093-7B60-4029-8DE2-7BD7C15840BE/' + 'ffttDqL0OWSYgfyxHrA8qKuzGtV2/').once('value', snapshot => {

 //  var item = snapshot.val();
  var name = snapshot.val();
   // var item = snapshot.val()
    console.log('Este es el valor'  + name);

 })

});


exports.sendMensaje = functions.https.onRequest((request, response) => {
 response.send("Hello fPaPu!");

 var payload = {
   notification: {
     title: "Test",
     body: " Test "
   }
 }

 admin.messaging().sendToDevice(usuarios[property], payload)

});

// Devonoti

exports.observeDevocional = functions.database.ref('/Devonoti/{uid}').onCreate((snapshot, context)  => {

console.log('written by' + snapshot.val());

var churchID = snapshot.val()

return admin.database().ref('/ChurchsFollowers/' + churchID + '/').once('value', snapshot => {

  var payload = {
    notification: {
      title: "Hay un nuevo devocional para ti.",
      body: "Estamos juntos en un mismo sentir."
    }
  }

  // primer fecth que busca datos ... tenemos uid que es la iglesia ,,,, uid del seguidor y token del seguidor
  const usuarios = snapshot.val();

var tokensArray = ['']

for (const property in usuarios) {
  console.log(`${usuarios[property]}`);

  tokensArray.push(property);

admin.messaging().sendToDevice(usuarios[property], payload);

}
  return "Ok process"
  });

});

exports.observeEvents = functions.database.ref('/Eventnoti/{uid}').onCreate((snapshot, context)  => {

console.log('written by' + snapshot.val());

var churchID = snapshot.val()

return admin.database().ref('/ChurchsFollowers/' + churchID + '/').once('value', snapshot => {

  var payload = {
    notification: {
      title: "Hay un nuevo evento para la iglesia",
      body: "Estamos unidos en un mismo Espiritu"
    }
  }

  // primer fecth que busca datos ... tenemos uid que es la iglesia ,,,, uid del seguidor y token del seguidor
  const usuarios = snapshot.val();

var tokensArray = ['']

for (const property in usuarios) {
  console.log(`${usuarios[property]}`);

  tokensArray.push(property);

admin.messaging().sendToDevice(usuarios[property], payload);

}
  return "Ok process"
  });

});




exports.observePostVersion2 = functions.database.ref('/Postnoti/{uid}').onCreate((snapshot, context)  => {

console.log('written by' + snapshot.val());

var churchID = snapshot.val()

return admin.database().ref('/ChurchsFollowers/' + churchID + '/').once('value', snapshot => {

  var payload = {
    notification: {
      title: "Nuevo pedido de Oración",
      body: "Estemos unidos en un mismo Espiritu."
    }
  }

  // primer fecth que busca datos ... tenemos uid que es la iglesia ,,,, uid del seguidor y token del seguidor
  const usuarios = snapshot.val();

var tokensArray = ['']

for (const property in usuarios) {
  console.log(`${usuarios[property]}`);

  tokensArray.push(property);

admin.messaging().sendToDevice(usuarios[property], payload);

}
  return "Ok process"
  });

});






exports.observeFollowing = functions.database.ref('/ChurchsFollowers/{uid}/{followingId}')
  .onCreate((snapshot, context) => {

    var uid = context.params.uid;
    var followingId = context.params.followingId;

    return admin.database().ref('/ChurchsFollowers/' + uid + '/' + followingId + '/').once('value', snapshot => {

      // primer fecth que busca datos ... tenemos uid que es la iglesia ,,,, uid del seguidor y token del seguidor
      var item = snapshot.val()
      console.log('User: ' + followingId + ' is following: ' + uid + ' Este es el item'  + item);


      // como sacamos tocken de la iglesia ----  token de la iglesia

     return admin.database().ref('/Churchs/' + uid + '/' + 'fcmToken' + '/').once('value', snapshot => {

       var tokenChurch = snapshot.val()


       console.log('Este es el tocken de la church'  + tokenChurch);


           var payload = {
             notification: {
               title: "Un nuevo usuario se agrego.",
               body: "Buen trabajo! "
             }
           }

        return admin.messaging().sendToDevice(tokenChurch, payload)



       })


    })

  })
