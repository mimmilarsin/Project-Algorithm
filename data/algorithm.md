# Algorithm Pseudocode

## Algorithm Task(s)

For a set of publications, determine the (1) number of collaborators and (2) collaboration types.

### Task 1 Code
```
Get dataset.csv
Add column collabNum

For each publication of dataset:
    If (publication authors == 1) Then
        Set collabNum to "individual"
    ElseIf (publication authors == 2) Then
        Set collabNum to "pair"
    Else
        Set collabNum to "group"

Print dataset
```

### Task 2 Code
```
Get dataset.csv
Add column collabType

For each publication:
    If (publication author > 1) Then
        Separate into individual authors
    Else
        For each publication author:
            Separate into author name and affiliation
            If (author affiliation > 1) Then
                Separate affiliation
            Else
                For each author affiliation:
                    Separate into organization and country

For each publication:
    If (publication authors == 1) Then
        Set collabType to "no collaboration"
    ElseIf (organization == 1) Then
        Set collabType to "local"
    ElseIf (country == 1) Then
        Set collabType to "national"
    Else
        Set collabType to "international"

Print dataset
```