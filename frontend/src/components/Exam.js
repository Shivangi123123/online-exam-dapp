import React, { useState } from 'react';
import { ethers } from 'ethers';
import ExamContractABI from '../ExamContractABI.json'; // Assuming ABI is available

const Exam = () => {
    const [questions, setQuestions] = useState([
        { questionText: "What is 2+2?" },
        { questionText: "What is the capital of France?" },
        { questionText: "What is the largest ocean?" },
        { questionText: "What is 5*6?" },
        { questionText: "What is the boiling point of water?" }
    ]);
    const [answers, setAnswers] = useState(new Array(5).fill(""));
    const [marks, setMarks] = useState(null);

    const submitAnswers = async () => {
        const hashedAnswers = answers.map(answer => 
            ethers.utils.keccak256(ethers.utils.toUtf8Bytes(answer))
        );

        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(process.env.REACT_APP_CONTRACT_ADDRESS, ExamContractABI, signer);

        await contract.submitAnswers(1, hashedAnswers); // Assuming exam ID is 1
        const result = await contract.getMarks(1); // Get marks for the exam
        setMarks(result.toNumber());
    };

    return (
        <div>
            <h2>Online Exam</h2>
            {questions.map((question, index) => (
                <div key={index}>
                    <p>{question.questionText}</p>
                    <input 
                        type="text" 
                        value={answers[index]}
                        onChange={e => {
                            let newAnswers = [...answers];
                            newAnswers[index] = e.target.value;
                            setAnswers(newAnswers);
                        }} 
                    />
                </div>
            ))}
            <button onClick={submitAnswers}>Submit</button>
            {marks !== null && <p>Your marks: {marks}/5</p>}
        </div>
    );
};

export default Exam;
