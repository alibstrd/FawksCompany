const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const stripe = require("stripe")(functions.config().stripe.secret_test_key);

exports.createStripeCustomer = functions.firestore
  .document("user/{userId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const email = data.email;

    const customer = await stripe.customers.create({ email: email });
    return admin
      .firestore()
      .collection("user")
      .doc(data.id)
      .update({ stripeId: customer.id });
  });

// Firebase callable function
exports.createEphemeralKey = functions.https.onCall(async (data, context) => {
  const customerId = data.customer_id;
  const stripeVersion = data.stripe_version;
  // const uid = context.auth.uid;

  // if (uid === null) {
  //   console.log("Illegal access attempt due to unauthenticated user");
  //   throw new functions.https.HttpsError(
  //     "permission-denied",
  //     "Illegal access attempt."
  //   );
  // }

  return stripe.ephemeralKeys
    .create({ customer: customerId }, { stripe_version: stripeVersion })
    .then((key) => {
      return key;
    })
    .catch((err) => {
      console.log(err);
      throw new functions.https.HttpsError(
        "internal",
        "Unable to create ephemeral keys"
      );
    });
});

exports.makeCharge = functions.https.onCall(async (data, context) => {
  const paymentMethodId = data.payment_method_id;
  const customerId = data.customer_id;
  const totalAmount = data.total_amount;
  const idempotency = data.idempotency;
  // const uid = context.auth.uid;

  // if (uid === null) {
  //   console.log("Illegal access attempt due to unauthenticated user");
  //   throw new functions.https.HttpsError(
  //     "permission-denied",
  //     "Illegal access attempt."
  //   );
  // }

  return stripe.paymentIntents
    .create(
      {
        payment_method: paymentMethodId,
        amount: totalAmount,
        currency: "usd",
        customer: customerId,
        confirm: true,
        payment_method_types: ["card"],
      },
      {
        idempotency_key: idempotency,
      }
    )
    .then((intent) => {
      console.log("Charge success!", intent);
      return;
    })
    .catch((err) => {
      console.log(err);
      throw new functions.https.HttpsError(
        "internal",
        "Unable to create charge."
      );
    });
});

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", { structuredData: true });
//   response.send("Hello from Fawks Company!");
// });
