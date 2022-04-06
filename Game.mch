/* Game
 * Author: Sarvetha | w1742121 | 2018427
 * Creation date: 27-Jan-22
 */
MACHINE
    Game
    
SETS
     REPORT = { MOVEMENT_SUCCESSFUL, GO_DOWN_SNAKE, CLIMB_UP_LADDER, NORMAL_SQUARE, HIGH_DICE_VALUE_TO_FINISH_GAME, GAME_ALREADY_ENDED_PLEASE_START_A_NEW_GAME, WIN_GAME, GAME_WON, GAME_NOT_OVER };
    
    GAME_STATUS = { GameWon, GameNotOver }
    
CONSTANTS
    Board,
    Dice,
    StartPosition,
    EndPosition,
    Snakes,
    Ladders
    
PROPERTIES
    Board = 1..100 &
    Dice = 1..6 &
    StartPosition : Board &
    StartPosition = 1 &
    EndPosition : Board &
    EndPosition = 100 &
    Snakes : Board <-> Board &
    Ladders : Board <-> Board &
    Snakes = {16 |-> 13, 31 |-> 4, 47 |-> 25, 63 |-> 60, 66 |-> 52, 97 |-> 75} &
    Ladders = {3 |-> 39, 10 |-> 12, 27 |-> 53, 56 |-> 84, 61 |-> 99, 72 |-> 90}
    
VARIABLES
    currentPosition,
    diceValue,
    noOfMoves,
    no0fSnakesGoneDown,
    noOfLaddersGoneUp,
    visitedPosition,
    gameStatus

INVARIANT
    currentPosition : Board &
    diceValue : Dice &
    noOfMoves : NATURAL1 &
    no0fSnakesGoneDown : NATURAL1 &
    noOfLaddersGoneUp : NATURAL1 &
    visitedPosition : seq(Board) &
    gameStatus <: GAME_STATUS
    
INITIALISATION
    currentPosition := 1 ||
    no0fSnakesGoneDown := 0 ||
    noOfLaddersGoneUp := 0 ||
    noOfMoves := 0 ||
    gameStatus := { GameNotOver } ||
    visitedPosition := [1] ||
    diceValue := 1
    
DEFINITIONS
    isLadder( box ) == ( box : dom(Ladders)); 
    isSnake( box ) == ( box : dom(Snakes));
    isTooHighValueToFinish(box) == ( box > EndPosition );
    isWon(box) == ( box = EndPosition )

OPERATIONS
        
    report, square <-- RollDice(diceNum) =
    PRE
        report : REPORT &
        diceNum : Dice
    THEN
        IF
            (GameNotOver : gameStatus)
        THEN
            IF
                (isWon(currentPosition + diceNum))
            THEN
                currentPosition:= currentPosition + diceNum||
                square := currentPosition + diceNum ||
                visitedPosition := visitedPosition ^ [currentPosition + diceNum] ||
                noOfMoves := noOfMoves + 1 ||
                diceValue := diceNum ||
                gameStatus := { GameWon } ||
                report := WIN_GAME
            ELSIF
                (isTooHighValueToFinish(currentPosition + diceNum))
            THEN
                square := currentPosition + diceNum ||
                gameStatus := { GameNotOver } ||
                report := HIGH_DICE_VALUE_TO_FINISH_GAME
            ELSE
                IF
                    (isLadder(currentPosition + diceNum))
                THEN
                    currentPosition:=Ladders(currentPosition + diceNum)||
                    square := currentPosition + diceNum ||
                    visitedPosition := visitedPosition ^ [currentPosition + diceNum, Ladders(currentPosition + diceNum)] ||
                    noOfLaddersGoneUp := noOfLaddersGoneUp + 1 ||
                    noOfMoves := noOfMoves + 1 ||
                    diceValue := diceNum ||
                    gameStatus := { GameNotOver } ||
                    report := CLIMB_UP_LADDER
                ELSIF
                    (isSnake(currentPosition + diceNum))
                THEN
                    currentPosition:=Snakes(currentPosition + diceNum)||
                    square := currentPosition + diceNum ||
                    visitedPosition := visitedPosition ^ [currentPosition + diceNum, Snakes(currentPosition + diceNum)] ||
                    no0fSnakesGoneDown := no0fSnakesGoneDown + 1 ||
                    noOfMoves := noOfMoves + 1 ||
                    diceValue := diceNum ||
                    gameStatus := { GameNotOver } ||
                    report := GO_DOWN_SNAKE
                ELSE
                    currentPosition:= currentPosition + diceNum||
                    square := currentPosition + diceNum ||
    					   visitedPosition := visitedPosition ^ [currentPosition + diceNum] ||
    					   noOfMoves := noOfMoves + 1 ||
    					   diceValue := diceNum ||
    					   gameStatus := { GameNotOver } ||
    					   report := NORMAL_SQUARE
    			    END
            END
        END
    END;
                

/* 
*********************************************************************************************************************************
Mission Status
*********************************************************************************************************************************
*/
    
    snakes, ladders, moves, location, lastDice <-- MissionStatus =
    BEGIN
        snakes := no0fSnakesGoneDown ||
        ladders := noOfLaddersGoneUp ||
        moves := noOfMoves ||
        location := currentPosition ||
        lastDice := diceValue
    END;
 
    
/* 
*********************************************************************************************************************************
Game Status
*********************************************************************************************************************************
*/
    
    report <-- GameStatus =
    PRE
        report : REPORT  
    THEN
        BEGIN
            IF
                ( GameWon : gameStatus )
            THEN
                report := GAME_WON
            ELSIF
                ( GameNotOver : gameStatus )
            THEN
                report := GAME_NOT_OVER
            END
        END
    END;   
    
    
/* 
*********************************************************************************************************************************
Visited Squares
*********************************************************************************************************************************
*/
     
    visitedSquares <-- Squares_Visited =
    
    BEGIN
        visitedSquares := visitedPosition 
    END;    
    
    
/* 
*********************************************************************************************************************************
Reset Game
*********************************************************************************************************************************
*/
   Reset_Game =
  
   BEGIN
        currentPosition := 1 ||
        no0fSnakesGoneDown := 0 ||
        noOfLaddersGoneUp := 0 ||
        noOfMoves := 0 ||
        gameStatus := { GameNotOver } ||
        visitedPosition := [1] ||
        diceValue := 1
    END
    
    
END