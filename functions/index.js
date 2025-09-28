const functions = require("firebase-functions");
const {GoogleGenerativeAI} = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(functions.config().gemini.key);

exports.generateText = functions.https.onCall(async (data, context) => {
  try {
    const prompt = data.prompt;
    const model = genAI.getGenerativeModel({model: "gemini-pro"});

    const result = await model.generateContent(prompt);
    const response = result.response.text();

    return {text: response};
  } catch (error) {
    console.error(error);
    throw new functions.https.HttpsError("internal", "AI request failed");
  }
});
