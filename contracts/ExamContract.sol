// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExamContract {
    struct Exam {
        uint id;
        string title;
        uint256 startTime;
        uint256 endTime;
        mapping(address => bool) candidates;
        Question[] questions;
        mapping(address => uint) marks;
    }

    struct Question {
        string questionText;
        bytes32 correctAnswerHash; // Store the hash of the correct answer
    }

    mapping(uint => Exam) public exams;
    uint public examCount;

    function createExam(string memory _title, uint256 _startTime, uint256 _endTime) public {
        examCount++;
        exams[examCount].id = examCount;
        exams[examCount].title = _title;
        exams[examCount].startTime = _startTime;
        exams[examCount].endTime = _endTime;
    }

    function addQuestion(uint _examId, string memory _questionText, bytes32 _correctAnswerHash) public {
        require(_examId > 0 && _examId <= examCount, "Invalid exam ID");
        require(exams[_examId].questions.length < 5, "Exam can only have 5 questions");
        exams[_examId].questions.push(Question(_questionText, _correctAnswerHash));
    }

    function registerCandidate(uint _examId) public {
        require(_examId > 0 && _examId <= examCount, "Invalid exam ID");
        exams[_examId].candidates[msg.sender] = true;
    }

    function submitAnswers(uint _examId, bytes32[] memory _answerHashes) public {
        require(_examId > 0 && _examId <= examCount, "Invalid exam ID");
        require(exams[_examId].candidates[msg.sender], "Not registered for exam");
        require(_answerHashes.length == 5, "You must answer all 5 questions");

        uint marks = 0;
        for (uint i = 0; i < _answerHashes.length; i++) {
            if (_answerHashes[i] == exams[_examId].questions[i].correctAnswerHash) {
                marks++;
            }
        }

        exams[_examId].marks[msg.sender] = marks;
    }

    function getMarks(uint _examId) public view returns (uint) {
        require(_examId > 0 && _examId <= examCount, "Invalid exam ID");
        return exams[_examId].marks[msg.sender];
    }
}
