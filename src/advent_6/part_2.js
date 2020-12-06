const { readGroups, FILE } = require("./part_1");

const countCommonQuestions = (group) => {
  const groupQuestions = {};
  group.groupQuestions.forEach((userQuestions) => {
    for (const questionIndex in userQuestions) {
      const question = userQuestions[questionIndex];
      if (!groupQuestions[question]) {
        groupQuestions[question] = 0;
      }
      groupQuestions[question] += 1;
    }
  });
  return Object.values(groupQuestions).filter(
    (value) => value == group.groupQuestions.length
  ).length;
};

const showTotalCommonCount = (groups) => {
  const reducer = (count, group) => count + countCommonQuestions(group);
  const count = groups.reduce(reducer, 0);
  console.log(`Total yes count is ${count}`);
};

readGroups(FILE, showTotalCommonCount);
