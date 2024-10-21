const functions = require("firebase-functions/v2");
const admin = require("firebase-admin");
admin.initializeApp();

exports.calculateRankings =
functions.scheduler.onSchedule("40 11 * * 6", async (event) => {
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





// 변경데이터 있는 애만 선별실행 및 100위까지만

/*
exports.calculateRankings = functions.scheduler.onSchedule("40 11 * * 6", async (event) => {
  const rankingRef = admin.firestore().collection("rankings");
  const lastUpdateDoc = await rankingRef.doc("lastUpdate").get();
  const lastUpdateTime = lastUpdateDoc.exists ? lastUpdateDoc.data().timestamp : new Date(0);

  const usersSnapshot = await admin.firestore()
    .collection("users")
    .where("lastUpdated", ">", lastUpdateTime)
    .get();

  if (usersSnapshot.empty) {
    console.log("No users updated since last ranking calculation.");
    return null;
  }

  const updatedUsers = usersSnapshot.docs.map(doc => ({
    id: doc.id,
    displayName: doc.data().displayName,
    exp: doc.data().exp,
    totalPrize: doc.data().totalPrize,
    winningRate: doc.data().winningRate,
    photoUrl: doc.data().photoUrl,
  }));

  // 기존 랭킹 데이터 가져오기
  const [expRanking, prizeRanking, winningRateRanking] = await Promise.all([
    rankingRef.doc("exp").get(),
    rankingRef.doc("totalPrize").get(),
    rankingRef.doc("winningRate").get(),
  ]);

  let expRankedUsers = expRanking.exists ? expRanking.data().users : [];
  let prizeRankedUsers = prizeRanking.exists ? prizeRanking.data().users : [];
  let winningRateRankedUsers = winningRateRanking.exists ? winningRateRanking.data().users : [];

  // 업데이트된 사용자 데이터로 랭킹 갱신
  updatedUsers.forEach(user => {
    expRankedUsers = updateRanking(expRankedUsers, user, 'exp');
    prizeRankedUsers = updateRanking(prizeRankedUsers, user, 'totalPrize');
    winningRateRankedUsers = updateRanking(winningRateRankedUsers, user, 'winningRate');
  });

  // 상위 100명만 유지
  expRankedUsers = expRankedUsers.slice(0, 100);
  prizeRankedUsers = prizeRankedUsers.slice(0, 100);
  winningRateRankedUsers = winningRateRankedUsers.slice(0, 100);

  const batch = admin.firestore().batch();

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

  batch.set(rankingRef.doc("lastUpdate"), {
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();
  console.log("Rankings updated successfully!");
  return null;
});

function updateRanking(rankedUsers, newUser, field) {
  const index = rankedUsers.findIndex(u => u.id === newUser.id);
  if (index !== -1) {
    rankedUsers.splice(index, 1);
  }
  rankedUsers.push(newUser);
  return rankedUsers.sort((a, b) => b[field] - a[field]);
}
*/
