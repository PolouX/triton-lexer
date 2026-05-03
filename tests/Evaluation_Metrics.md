# TC3002B Computer Science Advanced Applications Development
## Module #3: Compilers — Step I
### Lexical Analysis Phase (Triton GPU Kernel)

---

## I. Introduction

The evaluation of this challenge's phase is constituted by two parts. The first part is the evaluation of the functioning software, whose weight is **50%** of the total evaluation. The other **50%** will be formed by the quality correctness of the written report. The evaluation metrics for each part are shown in the following sections. For the evaluation of the functionality of the software, there will be an individual one-to-one session with each student, in which an oral exam will be applied to the student, and it will be applied as a multiplier of the total evaluation grade.

**Table 1 — Evaluation Summary**

| Component      | Weight |
|----------------|--------|
| Software       | 50%    |
| Written Report | 50%    |
| Oral Exam      | × 100% |

---

## CHALLENGE'S ACADEMIC INTEGRITY (CHEATING)

All work involved in the construction of the challenge **MUST be ENTIRELY understood** by the individual student. The project **MUST represent the student's INTELLECTUAL WORK**.

**SOFTWARE REUSE:** It is a Software Engineering strategy in which the development process is strongly based on existing software components, libraries, applications or/and algorithms.
> The student is **ONLY** allowed to reuse software that has been developed by the student him/herself on any activity of the TC-3048 Compiler Design course such as Lab Practices or Class Exercises.

**OPEN-SOURCE SOFTWARE:** Software which code is available to the public for review, inspection, modification, enhance and use by anyone with interest and permission.
> The student is **STRICTLY FORBIDDEN** to use open-source software, code freely available from the internet, or any software part NOT developed entirely by the student.

**AI USAGE:** During the lectures, you will receive all the required knowledge to solve the compiler's part of the challenge. Even though you will not need it, you are allowed to consult AI. However, the AI will give you code that is not 100% compatible with the course's material. Hence, you are **RESPONSIBLE** to understand every single line of code you deliver and be able to answer any question regarding it.

> **BE AWARE:** Any violation to the restrictions established in this document will be considered an act against the Institution's Academic Integrity Regulation.
>
> **Cheating will generate a value of 0 (ZERO) assigned as the FINAL GRADE for the module, and an AIF (Academic Integrity Fault) report.**

---

## II. Triton Lexical Specification

The lexical analyzer or scanner is the first phase of the translation process of a compiler for any given programming language. The main purpose of the lexical phase is to identify the tokens or valid member strings of the programming language, in the order in which they appear in the source file. Another important task of the scanner is to construct the preliminary version of the symbol table for all kind of tokens, which will later be used by the syntax, semantics, and intermediate code generator phases.

For the challenge of our Learning Unit, you will implement a scanner using the **lex tool** to recognize the lexemes of the **Triton GPU kernel**. Triton is a Python-like domain-specific language (DSL) for writing GPU kernels. Developed by OpenAI, Triton allows developers to write high-performance GPU code using familiar Python syntax with specialized tensor operations.

The team will have to generate the informal lexical specification for the Triton GPU kernel language as approved by Dr. Salvador Hinojosa. Once approved, proceed to develop all the activities asked for the development of this part of the challenge.

The scanner must be able to identify all the necessary lexemes that conform the approved informal lexical specification. The following considerations shall be observed:

a) Include only the necessary keywords and special symbols to accomplish the goal.  
b) Disregard any unnecessary lexeme from the original language.  
c) Generate the corresponding error messages.

---

## III. Project Outcomes

### a) Scanner Output
The Scanner shall provide the following outputs:
1. Sequence of Tokens in the structure as was seen in class.
2. The required Symbol Table for those tokens that require it.

### b) Deliverables
The project must include the following deliverables:
1. The approved informal description of the lexemes required to achieve the goal.
2. The regular expression for each kind of token.
3. The automata that recognize the required lexemes.
4. Tokens and their identification (Token ID).
5. Transition Table.
6. Symbol Tables for the required tokens.
7. Implementation of the Scanner using UNIX-lex.
8. Example of the Scanner Outputs.

### c) Restrictions
1. The scanner **MUST** be implemented using `lex` as seen in class.
2. The scanner **CAN NOT** be implemented using any kind of Regular Expressions Libraries or APIs native to the programming language.
3. You **CAN NOT** use Python's built-in `ast` module.

---

## IV. Scanner Software Evaluation Metrics

| Aspect | 100 | 80 | 60 | 40 | 20 | 0 | Weight |
|--------|-----|----|----|----|----|---|--------|
| **Software Complies with Requirements** | 1. Software runs. 2. Scanner recognizes all tokens. 3. Scanner recognizes invalid symbols and provides error messages. 4. Lexical analyzer provides a list of tokens. 5. Scanner provides the Symbol Table for all valid tokens. | Runs and recognizes all tokens but does not comply with **one** other feature. | Runs and recognizes all tokens but does not comply with **two or more** other features. | N/A | N/A | Software does not run, failed to identify all tokens, uses RE API, or does not use lex. | **80** |
| **Comments in Source Code** | 1. Extraordinarily explained and documented. 2. All files include functionality description. 3. All functions/methods/classes are clearly described. 4. Comments are unambiguous, complete, and correct. | All code is commented but meaning is hard to understand. | Comments are incomplete, ambiguous, or incorrect. | N/A | Extremely poor comments. | No comments. | **5** |
| **Traceability** | 1. Every functional requirement maps to a specific piece of code. 2. Code complies with design. 3. Design maps directly to implementation. | N/A | N/A | N/A | N/A | Poor traceability, uses RE API, or does not use lex. | **5** |
| **Testing** | Scanner passes all test cases given by the professor. | N/A | N/A | N/A | N/A | Scanner does not pass all test cases. | **10** |

---

## V. Oral Exam Evaluation Metrics

| Aspect | 100 | 80 | 60 | 40 | 20 | 0 | Weight |
|--------|-----|----|----|----|----|---|--------|
| **Software Questions** | Student proves complete knowledge of the code and can answer any questions regarding: 1. Functionality. 2. Code. 3. Source files. | N/A | Student fails to answer any question correctly. | N/A | Student does not prove complete knowledge of the code. However, there is no evidence of cheating. | Cheating | **60** |
| **Software Modifications** | Student is able to on-the-fly modify the code with regard to any change or new functional requirement given by the professor. | N/A | N/A | N/A | Student is not able to modify the code on-the-fly. However, there is no evidence of cheating. | Cheating | **30** |
| **Development Process** | Student can answer any questions regarding: 1. Functional Requirements. 2. Analysis. 3. Design. 4. Implementation. | N/A | N/A | N/A | Student is not able to answer all questions. However, there is no evidence of cheating. | Cheating | **10** |

> **Important:** The above points are maximum margins. 100 will be obtained if and only if all items are satisfied in an excellent manner according to the professor's criteria.

---

## VI. Written Report

Once all features are clearly and concisely formulated, the following step is to implement the development of the software system project process model. The development of the scanner should be based on the **IEEE-830 standard**.

The report structure must include the following sections:

### 1. Introduction
**1.1 Summary** — Brief description of the contents of this report.

**1.2 Notation** — Brief description of finite state machines, regular expressions, and transition tables:
- Explain the model used for the development of the analysis and design phases.
- Justification for the selected model.
- Explanation and justification of the programming language used (lex tool).

### 2. Analysis
Describe the requirements of the system represented by the eight deliverables for the scanner. Must include:
- Informal lexical description of the language.
- Formal specification in the form of regular expressions for each kind of token.
- Description of all considerations taken to develop these models.
- Explanation of every regular expression and how they comply with the Lexical Definition of the challenge's goal.

### 3. Design
The design **MUST** include:
- A complete and consistent set of design diagrams (state and flow diagrams, module diagrams, etc.).
- Pseudo code to complement state and flow diagrams.
- A precise DFA that recognizes all tokens from the analysis phase.
- The most efficient Transition Table with Token IDs.
- Algorithmic description and data structures required to implement the Symbol Tables.

> The design **MUST BE TRACEABLE TO THE ANALYSIS MODEL** — for every functional requirement specified during analysis, the design shall explicitly describe "how" it will be implemented.

### 4. Implementation
A complete printout of the lex file for the scanner must be provided, completely explaining each code element of the three sections:

a) Definition Section.  
b) Rules Section.  
c) User Code Section.

### 5. Verification and Validation
Present a Test Model consisting of:
- Software Test Cases design.
- Set of test files and their expected results.
- Snapshots of the Scanner's output for each test case with corresponding explanation.

> Your implementation **MUST** pass your own test files **as well as** the professor's test cases.

### 6. References
Use **IEEE Reference Style** with numeric references enclosed in square brackets.

**Examples:**

| Type | Format |
|------|--------|
| Book | Author, *Title*, (Publisher, Year), pages. |
| Journal | Author, "Article Title", *Journal Name* vol, no. (Date): pages. |
| Internet | Author, *Title* [type-online] (Publisher, Year, accessed date); available from URL; Internet. |
| Lecture Notes | Author, Class Lecture, Topic: "Title." Course, Institution, Location, Date. |

---

## Written Report Evaluation Metrics

| Aspect | 100 | 80 | 60 | 40 | 20 | 0 | Weight |
|--------|-----|----|----|----|----|---|--------|
| **General Aspects of the Report** | 1. Title Page. 2. Introduction. 3. Analysis. 4. Design. 5. Implementation. 6. Testing. 7. Work Plan. 8. References. | N/A | N/A | N/A | N/A | Incomplete Document | **2** |
| **Document Presentation and Format** | 1. Computer edited. 2. Quality of printing. 3. Page numbers. 4. Sections and subsections. 5. Figures/Tables have number and subtitle. 6. Figures/Tables referenced in text. 7. Correct distribution of text, figures, tables. 8. All references in bibliography (Chicago Manual Style). 9. Professionalism and quality (spiral binding or professional folder). | N/A | N/A | Does not comply with any aspects. | N/A | Incomplete Document | **3** |
| **Orthography and Typography** | 0 errors | N/A | N/A | N/A | N/A | Any error | **10** |
| **Introduction** | Section is extremely well developed; congruent and relevant, including summary and notation. | Congruent and relevant, including summary and notation. | Poorly developed but complete. | Poorly developed and incomplete. | Ambiguous, incoherent, and poorly related to the work. | Section does not exist. | **2** |
| **Analysis** | 1. Complete informal specification. 2. Formal specification using RE. 3. Description and justification of tokens. 4. Complete description of error messages. 5. Comprehensive, coherent narrative. | Minor discrepancies; information is sound and traceable. Poor narrative. | Major discrepancies; difficult to trace. However scanner works. | N/A | N/A | Specification is ambiguous/inconsistent/incomplete/incorrect, or uses RE API, or does not use lex. | **20** |
| **Design** | 1. Informal description. 2. Automata of the language. 3. Most efficient Transition Table. 4. List of Token IDs. 5. Symbol Table management, algorithm and data structures. 6. Traceable to analysis model. 7. Comprehensive, coherent narrative. | Minor discrepancies; information is sound and traceable. Poor narrative. | Traceability to analysis model is not clear. However scanner works. | N/A | N/A | Design is ambiguous/inconsistent/incomplete/incorrect, or uses RE API, or does not use lex. | **20** |
| **Implementation with lex** | 1. Lex code is completely and correctly traceable to analysis & design. 2. Every lex section is completely explained. 3. Comprehensive, coherent narrative. | Minor discrepancies; information is sound and traceable. Poor narrative. | Traceability to analysis model is not clear. However scanner works. | N/A | N/A | Scanner does not work and lex sections are not well developed/explained; or does not use lex. | **40** |
| **Testing** | 1. Informal description. 2. Software Test Cases design. 3. Justification. | N/A | N/A | N/A | N/A | Section does not exist. | **3** |

> **Important:** Everything MUST be completely justified. The above points are maximum margins. 100 will be obtained if and only if all items are satisfied in an excellent manner according to the professor's criteria.
