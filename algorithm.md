# Algorithm Pseudocode

## Algorithm Task(s)

For a SET of publications, determine the (1) number of collaborators and (2) collaboration types.

### Task 1 Code
```
PROGRAM collabNum:  

OPEN dataset.csv  
READ column numberOfAuthors
CREATE column collabNum
SET position to 0  

WHILE (position < length - 1)  
    IF (numberOfAuthors == 1)
        SET collabNum[position] to "individual"
        SET position to position + 1 
    ELSEIF (numberOfAuthors == 2)
        SET collabNum[position] to "pair"
        SET position to position + 1
    ELSE
        SET collabNum[position] to "group"
        SET position to position + 1

Return dataset
```

### Task 2 Code
```
PROGRAM collabType:

OPEN dataset.csv
READ column numberOfAuthors
READ column author
CREATE column collabType
SET position to 0

WHILE (position < length - 1)
    IF (numberOfAuthors > 1)
        SEPARATE authors at deliminator
        FOR each author
            SEPARATE affiliation at deliminator
            SEPARATE country at deliminator
            IF (all authors have the same country)
                IF (all authors have the same affiliation)
                    SET collabType to "local"
                ELSE
                    SET collabType to "national"
            ELSE
                SET collabType to "international"
        SET position to position + 1
    ELSE
        SET collabType to "individual"
        SET position to position + 1

Return dataset
```