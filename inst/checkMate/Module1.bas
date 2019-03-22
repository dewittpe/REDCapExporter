Attribute VB_Name = "Module1"
Public lstcol As Integer
Public Function Pplte(mssg As String, ofst As Integer, clr As String)
    ActiveCell.Offset(0, ofst).Interior.Color = clr
    With ActiveSheet
        If (Len(.Cells(ActiveCell.Row, lstcol + 1).Value) < 1) Then
        .Cells(ActiveCell.Row, lstcol + 1).Value = mssg
       Else
        If (InStr(.Cells(ActiveCell.Row, lstcol + 1).Value, mssg) = 0) Then
            .Cells(ActiveCell.Row, lstcol + 1).Value = .Cells(ActiveCell.Row, lstcol + 1).Value & "," & mssg
            .Cells(ActiveCell.Row, lstcol + 1).HorizontalAlignment = xlLeft
        End If
       End If
        .Cells(ActiveCell.Row, lstcol + 1).Interior.Color = clr
    End With
End Function

Public Function PplteGd(mssg As String, ofst As Integer, clr As String)
    ActiveCell.Offset(0, ofst).Interior.Color = clr
    With ActiveSheet
       If (Len(.Cells(ActiveCell.Row, lstcol + 2).Value) < 1) Then
        .Cells(ActiveCell.Row, lstcol + 2).Value = mssg
       Else
        If (InStr(.Cells(ActiveCell.Row, lstcol + 2).Value, mssg) = 0) Then
            .Cells(ActiveCell.Row, lstcol + 2).Value = .Cells(ActiveCell.Row, lstcol + 2).Value & "," & mssg
            .Cells(ActiveCell.Row, lstcol + 2).HorizontalAlignment = xlRight
        End If
       End If
        .Cells(ActiveCell.Row, lstcol + 2).Interior.Color = clr
    End With
End Function
Sub FrFrmTxt(lRow)
    Dim rngCal As Range
    Dim ntCll As Integer
    Dim txtCll As Integer
    Dim allCll As Integer
    Dim cllP As Integer
    
    ntCll = 0
    txtCll = 0
    txtAllCll = 0
    allCll = 0
    cllP = 0
    
    Set rngCal = Range("D2:" & Range("D65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngCal
       Cell.Select
       
       allCll = allCll + 1
       
       ' If (InStr(LCase(ActiveCell.Value), LCase("notes"))) Then
       '   ntCll = ntCll + 1
       ' End If
       
       If (InStr(LCase(ActiveCell.Value), LCase("text"))) Then
          txtAllCll = txtAllCll + 1
       If ActiveCell.Offset(0, 4).Value = "" Then
          txtCll = txtCll + 1
       End If
       End If
    Next
    
    cllP = ((ntCll + txtCll) / allCll) * 100
    
    Range("A" & lRow).Select
    ActiveCell.FormulaR1C1 = "General Recommendations:"
    With ActiveCell.EntireRow.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0.799981688894314
        .PatternTintAndShade = 0
    End With
    
    Range("A" & (lRow + 1)).Select
    ActiveCell.FormulaR1C1 = cllP & "% of the fields in this study are free form text (Number Text fields: " & txtAllCll & "). If responses can be categorized, consider using a dropdown field type to reduce risk of data entry error and make the data easier to analyze."
    With ActiveCell.EntireRow.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0.799981688894314
        .PatternTintAndShade = 0
    End With
     
End Sub
Sub FrmLngth(lRow)
    Dim rngCal As Range
    Dim nmFrms As Integer
    Dim oldFrm As String
    Dim nmFlds As Integer
    Dim lngFrms As Integer
    
    nmFrms = 0
    oldFrm = ""
    nmFlds = 0
    lngFrm = 0
    
    Set rngCal = Range("B2:" & Range("B65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngCal
       Cell.Select
       
       If ((oldFrm = "") Or (oldFrm <> ActiveCell.Value)) Then
        oldFrm = ActiveCell.Value
        If nmFlds > 30 Then
            lngFrms = lngFrms + 1
        End If
        nmFrms = nmFrms + 1
        nmFlds = 0
       End If
       
       
       nmFlds = nmFlds + 1
    
    Next
    
    If nmFlds > 30 Then
            lngFrms = lngFrms + 1
    End If
    
    Range("A" & lRow).Select
    
    Range("A" & (lRow + 2)).Select
    
    If lngFrms > 0 Then
    ActiveCell.FormulaR1C1 = lngFrms & " out of " & nmFrms & " forms in this study have more than 30 fields.  Consider creating shorter forms for better data entry."
    Else
    ActiveCell.FormulaR1C1 = " 0 out of " & nmFrms & " forms in this study have more than 30 fields."
    End If
    
    With ActiveCell.EntireRow.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorLight2
        .TintAndShade = 0.799981688894314
        .PatternTintAndShade = 0
    End With
     
End Sub
Sub PssblPHI()

' make Age upper case on purpose, seems to be lots of [age] in words

    Dim rngTextType As Range
    Dim upperLimitArray As Integer
    Dim readStringArray

    readStringArray = Array("name", "address", "street", "city", "state", "zip", "postal code", "phone", "email", "e-mail", "dob", "birth", "phone", "fax", "cell phone", "cell number", "pager", "website", _
                            "medical record number", "mrn", "ssn", "social security number", "account number", "health plan number", "insurance number")
    upperLimitArray = UBound(readStringArray)
    
    Set rngTextType = Range("E2:" & Range("E65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      'check Age
       If InStr(LCase(ActiveCell.Offset(0, -1).Value), LCase("text")) _
            Or InStr(LCase(ActiveCell.Offset(0, -1).Value), LCase("notes")) Then
       
        If InStr((ActiveCell.Value), ("Age")) Then
          If LCase(ActiveCell.Offset(0, 6).Value) <> "y" Then
              Call Pplte(1, 6, 65535)
          Else
              Call PplteGd(1, 6, 5296274)
          End If
        End If
        
       'if there is a text validator and implies phi, flag
        If InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("email")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("phone")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("ssn")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("postal")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("zipcode")) Then
          If LCase(ActiveCell.Offset(0, 6).Value) <> "y" Then
              Call Pplte(1, 6, 65535)
          Else
              Call PplteGd(1, 6, 5296274)
          End If
        End If
        
        
        For ForLoopCounter = 0 To upperLimitArray
        If InStr(LCase(ActiveCell.Value), LCase(readStringArray(ForLoopCounter))) Then
          If LCase(ActiveCell.Offset(0, 6).Value) <> "y" Then
              Call Pplte(1, 6, 65535)
          Else
              Call PplteGd(1, 6, 5296274)
          End If
        End If
        Next ForLoopCounter
      End If
      ' if Age if calculated field
      If (InStr(LCase(ActiveCell.Offset(0, -1).Value), LCase("calc")) _
          And (InStr((ActiveCell.Value), ("Age")) _
            )) Then
          If LCase(ActiveCell.Offset(0, 6).Value) <> "y" Then
              Call Pplte(1, 6, 65535)
          Else
              Call PplteGd(1, 6, 5296274)
          End If
      End If
    Next
End Sub
Sub PssblPHIFA()

' make Age upper case on purpose, seems to be lots of [age] in words

    Dim rngFAType As Range
    Dim upperLimitArray As Integer
    Dim readStringArray

    readStringArray = Array("latitude", "longitude", "default")
    upperLimitArray = UBound(readStringArray)
    
    Set rngFAType = Range("R2:" & Range("R65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngFAType
      Cell.Select
        
      If InStr(LCase(ActiveCell.Value), LCase("latitude")) _
            Or InStr(LCase(ActiveCell.Value), LCase("longitude")) _
            Or InStr(LCase(ActiveCell.Value), LCase("default")) Then
            
       'potential, check if should flag
        If LCase(ActiveCell.Offset(0, -7).Value) <> "y" Then
            Call Pplte(1, -7, 65535)
        Else
            Call PplteGd(1, -7, 5296274)
        End If
        
     End If
    Next
End Sub
Sub Cnsstnt(wordCheck)

    Dim rngTextType As Range
    Dim upperLimitArray As Integer
    Dim readStringArray
    Dim positionLast As Integer
    Dim positionFirst As Integer
    Dim firstTime As Integer
    Dim oldValue As String
    Dim wordValue As String
    
    positionLast = 0
    positionFirst = 0
    firstTime = 1
    oldValue = ""
    wordValue = "aaa"

    readStringArray = Array("," + wordCheck)
    upperLimitArray = UBound(readStringArray)
    
    Set rngTextType = Range("F2:" & Range("F65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      
      'check for consistancy
      
        For ForLoopCounter = 0 To upperLimitArray
        If InStr(Replace(LCase(ActiveCell.Value), " ", ""), LCase(readStringArray(ForLoopCounter))) Then
          
          positionLast = InStr(Replace(LCase(ActiveCell.Value), " ", ""), LCase(readStringArray(ForLoopCounter)))
          positionFirst = InStrRev(Replace(LCase(ActiveCell.Value), " ", ""), "|", positionLast)
          oldValue = Left(Replace(LCase(ActiveCell.Value), " ", ""), positionLast - 1)
          oldValue = Right(oldValue, (positionLast - positionFirst) - 1)
          
           ' set the value of yes to the first value we find
          If (firstTime = 1) Then
            wordValue = oldValue
            firstTime = 0
          End If
        
        End If
        
        If ((InStr(oldValue, wordValue) = 0) And (firstTime = 0)) Then
            Call Pplte("8-" + wordCheck, 0, 65535)
            ' reset value back to original value
            oldValue = wordValue
        End If
        
        Next ForLoopCounter
        
    Next
End Sub
Sub Ccltns()
    Dim rngCal As Range
    
    Set rngCal = Range("F2:" & Range("F65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngCal
       Cell.Select
       Set c = Selection.Find(What:="today", MatchCase:=False, SearchFormat:=False)
       If Not c Is Nothing Then
            Call Pplte(3, 0, 65535)
       End If
    Next
End Sub
Sub AddrssLng()
    Dim rngTextType As Range


    Set rngTextType = Range("E2:" & Range("E65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      
      'try to break out the street, city, state, zip suggested by vanderbilt
        If InStr(LCase(ActiveCell.Value), "street, city, state, zip") Then
              Call Pplte(6, 0, 65535)
        End If

    Next
End Sub

Sub SggstMinMax(iNumMin As String, iNumMax As String)
    Dim rngTextType As Range
    
    Set rngTextType = Range("H2:" & Range("H65536").End(xlUp).Address(0, 0))
    
    ' textTypeLoop(rngTextType);
    
    For Each Cell In rngTextType
      Cell.Select
      If ((ActiveCell.Value = "number") _
        Or (ActiveCell.Value = "integer")) Then
          If ActiveCell.Offset(0, 1).Value = "" Then
              Call Pplte(iNumMin, 1, 65535)
          Else
              Call PplteGd(iNumMin, 1, 5296274)
          End If
      End If
      If ((ActiveCell.Value = "number") _
        Or (ActiveCell.Value = "integer")) Then
          If ActiveCell.Offset(0, 2).Value = "" Then
              Call Pplte(iNumMax, 2, 65535)
          Else
              Call PplteGd(iNumMax, 2, 5296274)
          End If
      End If
    Next
End Sub
Sub SggstMinMaxDate(dNumMin As String, dNumMax As String)
    Dim rngTextType As Range
    
    Set rngTextType = Range("H2:" & Range("H65536").End(xlUp).Address(0, 0))
    
    ' textTypeLoop(rngTextType);
    
    For Each Cell In rngTextType
      Cell.Select
      If ((ActiveCell.Value = "date")) Then
          If ActiveCell.Offset(0, 1).Value = "" Then
              Call Pplte(dNumMin, 1, 65535)
          Else
              Call PplteGd(dNumMin, 1, 5296274)
          End If
      End If
      If ((ActiveCell.Value = "date")) Then
          If ActiveCell.Offset(0, 2).Value = "" Then
              Call Pplte(dNumMax, 2, 65535)
          Else
              Call PplteGd(dNumMax, 2, 5296274)
          End If
      End If
    Next
End Sub
Sub TxtVldtr()
Dim rngTextType As Range
Dim upperLimitArray As Integer
Dim readStringArray

    readStringArray = Array("date", "time", "zip", "phone", "cell phone", "cell number", "fax", "pager", "email", "dob", "ssn", "postal")
    upperLimitArray = UBound(readStringArray)
    
    Set rngTextType = Range("E2:" & Range("E65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      
      'if there is a text validator give positive feedback
        If InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("email")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("phone")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("date")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("time")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("integer")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("number")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("ssn")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("postal")) _
          Or InStr(LCase(ActiveCell.Offset(0, 3).Value), LCase("zipcode")) Then
              Call PplteGd(2, 3, 5296274)
        End If
        
      If InStr(LCase(ActiveCell.Offset(0, -1).Value), LCase("text")) Then
       For ForLoopCounter = 0 To upperLimitArray
        If InStr(LCase(ActiveCell.Value), LCase(readStringArray(ForLoopCounter))) Then
          If ActiveCell.Offset(0, 3).Value = "" Then
              Call Pplte(2, 3, 65535)
          Else
              Call PplteGd(2, 3, 5296274)
          End If
        End If
       Next ForLoopCounter
      End If
    Next

End Sub
Sub LabVldtr()
Dim rngTextType As Range
Dim upperLimitArray As Integer
Dim readStringArray
Dim upperLimitArray2 As Integer
Dim readStringArray2

    readStringArray = Array("weight", "height", "bmi", "cholesterol", "triglycerides", "hdl", "ldl", "arc", "albumin", "creatine", "glucose", "peptide", "wbc", "anc", "a1c", "(kg)", "cm")
    upperLimitArray = UBound(readStringArray)
    
    readStringArray2 = Array("ast", "hemo")
    upperLimitArray2 = UBound(readStringArray2)
    
    readStringArray3 = Array("(kg", "(cm", "(kilogram")
    upperLimitArray3 = UBound(readStringArray3)
    
    'Set rngTextType = Range("C2:" & Range("C65536").End(xlUp).Address(0, 0))
    Set rngTextType = Range("E2:" & Range("E65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      ' do I want to look for a lab form or go right to field label?
      ' for this round I go right to the field label
      
      'Look for one of the lab words
       For ForLoopCounter = 0 To upperLimitArray
         If InStr(LCase(ActiveCell.Value), LCase(readStringArray(ForLoopCounter))) Then
       'if lab word found is it a text field?
          If ActiveCell.Offset(0, -1).Value = "text" Then
       'if text field does it have integer or number validator?
            If ActiveCell.Offset(0, 3).Value = "" Then
              Call Pplte(3, 3, 65535)
            Else
              Call PplteGd(3, 3, 5296274)
            End If
          End If
         End If
       Next ForLoopCounter
      
      'problematic labs -- ast mainly because matches the word last
      '                    hemo mainly because matches the word chemo
      'and match on lab form also
      For ForLoopCounter = 0 To upperLimitArray2
        If (InStr(LCase(ActiveCell.Value), LCase(readStringArray2(ForLoopCounter))) _
           And (ActiveCell.Offset(0, -1).Value = "text")) Then
      'if ast found is it in a lab form?
          If InStr(LCase(ActiveCell.Offset(0, -4).Value), LCase("lab")) Then
      'if text field does it have integer or number validator?
            If ActiveCell.Offset(0, 3).Value = "" Then
              Call Pplte(3, 3, 65535)
            Else
              Call PplteGd(3, 3, 5296274)
            End If
          End If
        End If
      Next ForLoopCounter
      
      ' specific units
      For ForLoopCounter = 0 To upperLimitArray3
        If (InStr(LCase(ActiveCell.Value), LCase(readStringArray3(ForLoopCounter))) _
           And (ActiveCell.Offset(0, -1).Value = "text")) Then
      'if ast found is it in a lab form?
          If InStr(LCase(ActiveCell.Offset(0, -4).Value), LCase("lab")) Then
      'if text field does it have integer or number validator?
            If ActiveCell.Offset(0, 3).Value = "" Then
              Call Pplte(3, 3, 65535)
            Else
              Call PplteGd(3, 3, 5296274)
            End If
          End If
        End If
      Next ForLoopCounter
      
    Next

End Sub
Sub CnsstntAll()

    Dim rngTextType As Range
    Dim cllText, searchFor As String
    Dim cllVluCnt As Integer
    
    Dim upperLimitArray As Integer
    Dim readStringArray() As String
    
    searchFor = ""
    
    Set rngTextType = Range("F2:" & Range("F65536").End(xlUp).Address(0, 0))
    
    For Each Cell In rngTextType
      Cell.Select
      
      'just get list of words, do not include calculations or slider values
      
        If (ActiveCell.Value <> Empty) And (ActiveCell.Offset(0, -2).Value <> "slider") And (ActiveCell.Offset(0, -2).Value <> "calc") Then
            cllVluCnt = Len(ActiveCell.Value) - Len(Replace(ActiveCell.Value, "|", ""))
            
            readStringArray = Split(Replace(ActiveCell.Value, " ", ""), "|")
            
            For ForLoopCounter = 0 To cllVluCnt
             onlyAlpha = Split(readStringArray(ForLoopCounter), ",")
             ' need to include the comma lookup for those choices that contain commas
             If (InStr(LCase(searchFor), "," & LCase(onlyAlpha(1)) & "|") = 0) And (InStr(LCase(searchFor), "," & LCase(onlyAlpha(1)) & ",") = 0) Then
                searchFor = searchFor & readStringArray(ForLoopCounter) & "|"
             End If
    
            Next ForLoopCounter
            
        End If
    
    Next
    
    ' now that I have my list of words go back through the cell and look for inconsistancies
    
    Set rngTextType2 = Range("F2:" & Range("F65536").End(xlUp).Address(0, 0))
    
    readStringArray2 = Split(searchFor, "|")
    
    For Each Cell In rngTextType2
      Cell.Select
      
      If (ActiveCell.Value <> Empty) And (ActiveCell.Offset(0, -2).Value <> "slider") And (ActiveCell.Offset(0, -2).Value <> "calc") Then
        
        For ForLoopCounter2 = 0 To ((Len(searchFor) - Len(Replace(searchFor, "|", ""))) - 1)
        'what word are we looking for
          searchForAlpha = Split(readStringArray2(ForLoopCounter2), ",")
          If InStr(Replace(LCase(ActiveCell.Value), " ", ""), LCase(searchForAlpha(1))) Then
            'if we find the word what is the value, loop through cell because faster
            cellSplit = Split(Replace(ActiveCell.Value, " ", ""), "|")
            For j = 0 To (Len(ActiveCell.Value) - Len(Replace(ActiveCell.Value, "|", "")))
            'does this cell split contain the word we are looking for
             If InStr(LCase(cellSplit(j)), "," & LCase(searchForAlpha(1))) Then
             'if it does have word, split the cell again and check value
             'if not the same write message, must match exactly
             cellSplitNum = Split(cellSplit(j), ",")
             temp = StrComp(LCase((cellSplitNum(1))), LCase(searchForAlpha(1)))
             If (StrComp(LCase((cellSplitNum(1))), LCase(searchForAlpha(1))) = 0) Then
              If (StrComp((cellSplitNum(0)), LCase(searchForAlpha(0))) <> 0) Then
                Call Pplte("8-" + cellSplitNum(1), 0, 65535)
              End If
             End If
          End If
          Next j
          End If
        
        Next ForLoopCounter2
        
        'If ((InStr(oldValue, wordValue) = 0) And (firstTime = 0)) Then
            'Call Pplte("8-" + wordCheck, 0, 65535)
            '' reset value back to original value
            'oldValue = wordValue
        'End If
        
        'Next ForLoopCounter
     End If
     
    Next
End Sub

Sub Main()
Attribute Main.VB_ProcData.VB_Invoke_Func = "q\n14"
'
' dmValidation Macro
'
' Keyboard Shortcut: Ctrl+q
'
    ' Columns("A:A").Select
    ' Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove
    
    ' set up the mapping of values
    Dim LastRow As Long
    
    lstcol = Cells.Find(What:="*", _
            SearchDirection:=xlPrevious, _
            SearchOrder:=xlByColumns).Column
            
    ' column headers
    Cells(1, lstcol + 1).Select
    ActiveCell.FormulaR1C1 = "BP Suggest"
    Cells(1, lstcol + 2).Select
    ActiveCell.FormulaR1C1 = "BP Follow"
    
    LastRow = Cells.Find(What:="*", _
    SearchDirection:=xlPrevious, _
    SearchOrder:=xlByRows).Row
    
    LastRow = LastRow + 4
    
    ' code to estimate free form text, I will do this first because it is general, then onto more specific
    
    FrFrmTxt (LastRow)
    
    ' code to look for long forms
    
    FrmLngth (LastRow)
    
    ' populate mapping values
    ActiveCell.Offset(1, 0).FormulaR1C1 = "Specific Recommendations (not all recommendations listed below will apply to this study):"
    ActiveCell.Offset(1, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(2, 0).FormulaR1C1 = "1. Possible PHI.  Consider placing a 'Y' in column K [Identifier?]"
    ActiveCell.Offset(2, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(3, 0).FormulaR1C1 = "2. When using text fields, consider validating the field to expect a specific data type by entering it in column H [Text Validation Type]. Available options are: date, time, integer, number, zipcode, phone and email."
    ActiveCell.Offset(3, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(4, 0).FormulaR1C1 = "3. When entering common lab/physical exam values, consider validating the text field to expect number or integer values in column H [Text Validation Type]"
    ActiveCell.Offset(4, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(5, 0).FormulaR1C1 = "4. For text fields validated as integer or number consider entering a minimum expected value in columns I [Text Validation Min] to decrease risk of data entry error."
    ActiveCell.Offset(5, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(6, 0).FormulaR1C1 = "5. For text fields validated as date consider entering a minimum value in columns I [Text Validation Min] to decrease risk of data entry error."
    ActiveCell.Offset(6, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(7, 0).FormulaR1C1 = "6. For text fields validated as integer or number consider entering a maximum expected value in columns J [Text Validation Max] to decrease risk of data entry error."
    ActiveCell.Offset(7, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(8, 0).FormulaR1C1 = "7. For text fields validated as date consider entering a maximum expected value in column J [Text Validation Max] to decrease risk of data entry error."
    ActiveCell.Offset(8, 0).EntireRow.Interior.Color = 65535
    ' ActiveCell.Offset(9, 0).FormulaR1C1 = "8. One of more of the values in column F [Choices, Calculations, OR Slider Labels] is not consistant through out the data dictionary."
    ' ActiveCell.Offset(9, 0).EntireRow.Interior.Color = 65535
    ' ActiveCell.Offset(4, 0).FormulaR1C1 = "3. Statistical results will vary when using dynamic expressions (e.g. 'today') in calculations. Consider using a fixed date, e.g. 'date of enrollment'."
    ' ActiveCell.Offset(4, 0).EntireRow.Interior.Color = 65535
    ' ActiveCell.Offset(7, 0).FormulaR1C1 = "6. Consider making street, city, state and zip separate fields in the database"
    ' ActiveCell.Offset(7, 0).EntireRow.Interior.Color = 65535
    ActiveCell.Offset(10, 0).FormulaR1C1 = ""
    ActiveCell.Offset(10, 0).EntireRow.Interior.Color = 65535
    
    ActiveCell.Offset(9, 0).FormulaR1C1 = "Fields in green meet best practice guidelines"
    ActiveCell.Offset(9, 0).EntireRow.Interior.Color = 5296274
    ActiveCell.Offset(10, 0).FormulaR1C1 = "Note: Age is an Identifier only if over 89"
    ActiveCell.Offset(10, 0).EntireRow.Interior.Color = 5296274
    
    ' code to suggest Indetifier for possible PHI
    PssblPHI
    
    ' code to suggest Indetifier for possible PHI in Field Annotation
    PssblPHIFA
    
    ' code to suggest use of text field validators
    TxtVldtr
    
    ' code to suggest use of text field validators on lab values
    LabVldtr
    
    ' code to suggest min/max for integers and numbers, make sure to match the number
    ' value of the grid specific comments mentioned above
    SggstMinMax 4, 6
    
     ' code to suggest min/max for dates, make sure to match the number
     ' value of the grid specific comments mentioned above
    SggstMinMaxDate 5, 7
    
    ' code to get rid of today() in calculations
    ' Ccltns
    
    ' code to look for city, state, zip all in one field
    ' AddrssLng
    
    ' code to look for consistant yes code values
    ' Cnsstnt ("yes")
    
    ' code to look for consistant no code values
    ' Cnsstnt ("no")
    
     ' code to look for consistant no code values
    ' CnsstntAll
      
End Sub
