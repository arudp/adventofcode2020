const fs = require("fs");
const readLine = require("readline");

const FILE = "src/advent_6/input";
const LINE = "line";

class Group {
  constructor() {
    this.groupQuestions = [];
  }

  addUserQuestions(userQuestions) {
    this.groupQuestions.push(userQuestions);
  }

  getYesCount() {
    const counted = {};
    this.groupQuestions.forEach((userQuestions) => {
      for (let questionIndex in userQuestions) {
        counted[userQuestions[questionIndex]] = 1;
      }
    });
    return Object.keys(counted).length;
  }
}

const readGroups = (inputFile, processGroups) => {
  let lineReader = readLine.createInterface({
    input: fs.createReadStream(inputFile),
  });
  let group = new Group();
  let groups = [group];

  lineReader.on("close", () => processGroups(groups));
  lineReader.on(LINE, (line) => {
    if (!line) {
      group = new Group();
      groups.push(group);
    } else {
      group.addUserQuestions(line);
    }
  });
};

const showTotalCount = (groups) => {
  const reducer = (count, group) => count + group.getYesCount();
  const count = groups.reduce(reducer, 0);
  console.log(`Total yes count is ${count}`);
};

function part1() {
  readGroups(FILE, showTotalCount);
}

module.exports = { Group, readGroups, FILE };
