const functions = require("firebase-functions/v2");
const admin = require("firebase-admin");
admin.initializeApp();

exports.calculateRankings =
functions.scheduler.onSchedule("20 09 * * 5", async (event) => {
  const usersSnapshot = await admin.firestore().collection("users").get();

  const users = usersSnapshot.docs.map((doc) => ({
    id: doc.id,
    displayName: doc.data().displayName,
    exp: doc.data().exp,
    totalPrize: doc.data().totalPrize,
    winningRate: doc.data().winningRate,
    photoUrl: doc.data().photoUrl, // photoUrl 추가
  }));

  const expRankedUsers =
  [...users].sort((a, b) => b.exp - a.exp);

  const prizeRankedUsers =
  [...users].sort((a, b) => b.totalPrize - a.totalPrize);

  const winningRateRankedUsers =
  [...users].sort((a, b) => b.winningRate - a.winningRate);

  const batch = admin.firestore().batch();
  const rankingRef = admin.firestore().collection("rankings");

  batch.set(rankingRef.doc("exp"), {
    users: expRankedUsers,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  batch.set(rankingRef.doc("totalPrize"), {
    users: prizeRankedUsers,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  batch.set(rankingRef.doc("winningRate"), {
    users: winningRateRankedUsers,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();
  console.log("Rankings updated successfully!");
  return null;
});
