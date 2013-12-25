MicrosoftExcel:
global Workbook
global excel
global Sheet
global Cell
global Selection
global lLastRow ;整个表的最末尾行
global lLastColumn ;整个表最末尾列
global SelectionFirstRow ;当前选择内容首行
global SelectionFirstColumn ;当前选择内容首列
global SelectionLastColumn ;当前选择内容末列
global SelectionLastRow ;当前选择内容末行
global SelectionType ; 当前选择单元格类型 1=A1  2=A1:B1 4=A1:A2 16=A1:B2  18=A1:B1 A1:B2 20=A1:A2 A1:B2
global FontColor:= 0x0000ff ;填充字体颜色
global CellColor:= 0xffff00 ;填充表格颜色

	vim.comment("<Insert_Mode_XLMAIN>","insert模式")
	vim.comment("<Normal_Mode_XLMAIN>","normal模式")
	vim.comment("<XLMAIN_SheetReName>","重命名当前工作表名称")
	vim.comment("<XLMAIN_GoTo>","跳转到指定行列值的表格")
	vim.comment("<XLMAIN_SaveAndExit>","保存并退出")
	vim.comment("<XLMAIN_DiscardAndExit>","放弃修改并退出")

	;insert模式及快捷键
	vim.mode("insert","XLMAIN")
	vim.map("<esc>","<Normal_Mode_XLMAIN>","XLMAIN")

	;normal模式及快捷键
	vim.mode("normal","XLMAIN")
	vim.map("e","<Insert_Mode_XLMAIN>","XLMAIN")
	vim.map("<esc>","<Normal_Mode_XLMAIN>","XLMAIN")

	vim.map("0","<0>","XLMAIN")
	vim.map("1","<1>","XLMAIN")
	vim.map("2","<2>","XLMAIN")
	vim.map("3","<3>","XLMAIN")
	vim.map("4","<4>","XLMAIN")
	vim.map("5","<5>","XLMAIN")
	vim.map("6","<6>","XLMAIN")
	vim.map("7","<7>","XLMAIN")
	vim.map("8","<8>","XLMAIN")
	vim.map("9","<9>","XLMAIN")

	vim.map("u","<excel_undo>","XLMAIN")
	vim.map("<ctrl>r","<redo>","XLMAIN")

	vim.map("ZZ","<XLMAIN_SaveAndExit>","XLMAIN")
	vim.map("ZQ","<XLMAIN_DiscardAndExit>","XLMAIN")

	vim.map("cf","<XLMAIN_Color_Font>","XLMAIN")
	vim.map("cc","<XLMAIN_Color_Cell>","XLMAIN")
	vim.map("cmf","<XLMAIN_Color_Menu_Font>","XLMAIN")
	vim.map("cmc","<XLMAIN_Color_Menu_Cell>","XLMAIN")


    ;边框
    vim.map("bd","<XLMAIN_边框下框线>","XLMAIN")
    vim.map("bu","<XLMAIN_边框上框线>","XLMAIN")
    vim.map("bl","<XLMAIN_边框左框线>","XLMAIN")
    vim.map("br","<XLMAIN_边框右框线>","XLMAIN")
    vim.map("bs","<XLMAIN_边框四边框线>","XLMAIN")
    vim.map("bt","<XLMAIN_边框四边粗匣框线>","XLMAIN")

    vim.map("bn","<XLMAIN_边框无框线>","XLMAIN")
    vim.map("ba","<XLMAIN_边框所有框线>","XLMAIN")
    vim.map("ba","<XLMAIN_边框粗匣框线>","XLMAIN")

    ;vim.map("bd","<XLMAIN_边框上下框线>","XLMAIN")
    ;编辑
    vim.map("o","<XLMAIN_编辑插入新行在前>","XLMAIN")
    vim.map("O","<XLMAIN_编辑插入新行在后>","XLMAIN")
    vim.map("t","<XLMAIN_编辑插入新列在右>","XLMAIN")
    vim.map("T","<XLMAIN_编辑插入新列在左>","XLMAIN")
    vim.map("R","<XLMAIN_编辑替换>","XLMAIN")

	vim.map("ys","<XLMAIN_Copy_Selection>","XLMAIN")
	vim.map("yy","<XLMAIN_Copy_Row>","XLMAIN")
	vim.map("yc","<XLMAIN_Copy_Col>","XLMAIN")

    vim.map("yl","<XLMAIN_编辑自左侧复制>","XLMAIN")
    vim.map("myl","<XLMAIN_逐行编辑自左侧复制>","XLMAIN")
    vim.map("yr","<XLMAIN_编辑自右侧复制>","XLMAIN")
     vim.map("myr","<XLMAIN_逐行编辑自右侧复制>","XLMAIN")
    vim.map("yu","<XLMAIN_编辑自上侧复制>","XLMAIN")
    vim.map("yd","<XLMAIN_编辑自下侧复制>","XLMAIN")

	vim.map("p","<XLMAIN_Paste>","XLMAIN")
	vim.map("P","<XLMAIN_Paste_Select>","XLMAIN")


    ;行指令
    vim.map("rh","<XLMAIN_隐藏选择行>","XLMAIN")
    vim.map("rH","<XLMAIN_隐藏选择行取消>","XLMAIN")
    vim.map("rW","<XLMAIN_自适应宽度选择行>","XLMAIN")
    vim.map("rs","<XLMAIN_选择整行>","XLMAIN")
    vim.map("rd","<XLMAIN_删除选择行>","XLMAIN")
    vim.map("rw","<XLMAIN_编辑行宽指定值>","XLMAIN")
    vim.map("rf","<XLMAIN_行填充>","XLMAIN")
    ;列指令
    vim.map("ch","<XLMAIN_隐藏选择列>","XLMAIN")
    vim.map("cH","<XLMAIN_隐藏选择列取消>","XLMAIN")
    vim.map("cW","<XLMAIN_自适应宽度选择列>","XLMAIN")
    vim.map("cs","<XLMAIN_选择整列>","XLMAIN")
    vim.map("cw","<XLMAIN_编辑列宽指定值>","XLMAIN")


    ;vim.map("e","<XLMAIN_编辑行宽变窄>","XLMAIN")
    ;vim.map("E","<XLMAIN_编辑行宽变宽>","XLMAIN")
    ;vim.map("q","<XLMAIN_编辑列宽变窄>","XLMAIN")
    ;vim.map("Q","<XLMAIN_编辑列宽变宽>","XLMAIN")

    vim.map("h","<left>","XLMAIN")
    vim.map("l","<right>","XLMAIN")
    vim.map("k","<up>","XLMAIN")
    vim.map("j","<down>","XLMAIN")

    vim.map("H","<XLMAIN_向左选择>","XLMAIN")
    vim.map("L","<XLMAIN_向右选择>","XLMAIN")
    vim.map("K","<XLMAIN_向上选择>","XLMAIN")
    vim.map("J","<XLMAIN_向下选择>","XLMAIN")

    ;Selection.EntireRow.Hidden := True
    ;a 对齐命令
    vim.map("al","<XLMAIN_对齐左>","XLMAIN")
    vim.map("ar","<XLMAIN_对齐右>","XLMAIN")
    vim.map("ac","<XLMAIN_对齐水平中间>","XLMAIN")
    vim.map("ao","<XLMAIN_对齐垂直中间>","XLMAIN")
    vim.map("au","<XLMAIN_对齐顶>","XLMAIN")
    vim.map("ad","<XLMAIN_对齐底>","XLMAIN")

    ;i 填充命令
    vim.map("iu","<XLMAIN_填充向上>","XLMAIN")
    vim.map("id","<XLMAIN_填充向下>","XLMAIN")
    vim.map("il","<XLMAIN_填充向左>","XLMAIN")
    vim.map("ir","<XLMAIN_填充向右>","XLMAIN")
    ;f 过滤命令
    vim.map("ff","<XLMAIN_自动过滤开启>","XLMAIN")
    vim.map("fs","<XLMAIN_过滤等于当前单元格>","XLMAIN")
    vim.map("fl","<XLMAIN_过滤当前列下拉菜单>","XLMAIN")
    vim.map("fd","<XLMAIN_过滤打开筛选对话框>","XLMAIN")
    vim.map("f<","<XLMAIN_过滤小于当前单元格>","XLMAIN")
    vim.map("f>","<XLMAIN_过滤大于当前单元格>","XLMAIN")
    vim.map("fo","<XLMAIN_过滤大于等于当前单元格>","XLMAIN")
    vim.map("fu","<XLMAIN_过滤小于等于当前单元格>","XLMAIN")
    vim.map("f.","<XLMAIN_过滤非空单元格>","XLMAIN")
    vim.map("fb","<XLMAIN_过滤空单元格>","XLMAIN")
    vim.map("fa","<XLMAIN_过滤取消当前列>","XLMAIN")
    vim.map("fi","<XLMAIN_过滤包含当前单元格>","XLMAIN")
    vim.map("fe","<XLMAIN_过滤不包含当前单元格>","XLMAIN")
    vim.map("fB","<XLMAIN_过滤开头包含当前单元格>","XLMAIN")
    vim.map("fE","<XLMAIN_过滤末尾包含当前单元格>","XLMAIN")
    vim.map("fA","<XLMAIN_过滤取消所有列>","XLMAIN")



    ;:字体颜色命令

    ;;单元格颜色命令

    ;%页面设置命令

    ;^设置格式命令

    ;@视图指令

    ;-横向线颜色命令

    ;|纵向ActiveSheet.线颜色指令

    ;`字体命令
    vim.map("<shift>,","<XLmain_字体放大>","XLMAIN")
    vim.map("<shift>.","<XLmain_字体缩小>","XLMAIN")

    ;(名称
    vim.map("<shift>9n","<XLMAIN_名称工作簿定义>","XLMAIN")
    vim.map("<shift>9N","<XLMAIN_名称当前工作表定义>","XLMAIN")

    vim.map("gg","<XLMAIN_定位首个单元格>","XLMAIN")
    vim.map("G","<XLMAIN_定位尾个单元格>","XLMAIN")
    vim.map("grh","<XLMAIN_定位首行>","XLMAIN")
    vim.map("gre","<XLMAIN_定位尾行>","XLMAIN")
    ;vim.map("gch","<XLMAIN_moveRowLeft>","XLMAIN")
    ;vim.map("gce","<XLMAIN_定位尾列>","XLMAIN")

    vim.map("gt","<XLMAIN_工作表跳转下一个>","XLMAIN")
    vim.map("gT","<XLMAIN_工作表跳转上一个>","XLMAIN")

    vim.map("go","<XLMAIN_GoTo>","XLMAIN")


    ;工作表

    vim.map("wr","<XLMAIN_SheetReName>","XLMAIN")
    vim.map("w)","<XLMAIN_工作表移动向后>","XLMAIN")
    vim.map("w(","<XLMAIN_工作表移动向前>","XLMAIN")
    vim.map("wn","<XLMAIN_工作表新建>","XLMAIN")
    vim.map("wd","<XLMAIN_工作表删除当前>","XLMAIN")
    vim.map("wp","<XLMAIN_工作表复制当前>","XLMAIN")
    vim.map("w0","<XLMAIN_工作表选择首个>","XLMAIN")
    vim.map("w$","<XLMAIN_工作表选择尾个>","XLMAIN")
    vim.map("wc","<XLMAIN_工作表复制对话框>","XLMAIN")

    ;m多区域逐行处理
    vim.map("mr","<XLMAIN_逐行合并>","XLMAIN")
    ;vim.map("mbd","<XLMAIN_逐行边框下框线>","XLMAIN")
    ;vim.map("mbu","<XLMAIN_逐行边框上框线>","XLMAIN")
    ;vim.map("mbs","<XLMAIN_逐行边框外侧框线>","XLMAIN")
    ;vim.map("mbt","<XLMAIN_逐行边框粗匣框线>","XLMAIN")
    vim.map("mR","<XLMAIN_取消逐行合并>","XLMAIN")

    ;测试
    vim.map("t5","<XLMIAN_获取活动工作表边界>","XLMAIN")
    vim.map("t1","<LastRow>","XLMAIN")
    vim.map("t2","<LastColumn>","XLMAIN")

;Comment

;Trigger
;XLMAIN
return


XLMAIN_CheckMode()
{
	ControlGetFocus,ctrl,AHK_CLASS XLMAIN
	If RegExMatch(ctrl,"EXCEL61")
		Return True
	return False
}

<Normal_Mode_XLMAIN>:
    vim.Mode("normal","XLMAIN")
return

<Insert_Mode_XLMAIN>:
    vim.Mode("insert","XLMAIN")
return


<excel_undo>:
{
	send ^z
	return
}

<redo>:
{
	send ^y
	return
}

<XLMAIN_名称工作簿定义>:
{
    Excel_Selection()
    InputBox, OutputVar ,输入名称
    inputbox, comments ,输入注释
    address:=Selection.address
    Name:=OutputVar
    RefersToR1C1:=address
    excel.ActiveWorkbook.Names.Add(Name,RefersToR1C1)
    ActiveWorkbook.Names(OutputVar).Comment := "comments"
    objRelease(excel)
    return
}

<XLMAIN_名称当前工作表定义>:
{
    Excel_Selection()
    InputBox, OutputVar ,输入名称
    inputbox, comments ,输入注释
    address:=Selection.address
    Name:=OutputVar
    RefersToR1C1:=address
    excel.ActiveSheet.Names.Add(Name,RefersToR1C1)
    ActiveSheet.Names(OutputVar).Comment := "comments"
    objRelease(excel)
    return
}

;控制
<XLMAIN_向左选择>:
{
    send,+{left}
    return
}


<XLMAIN_向右选择>:
{
    send,+{right}
    return
}

<XLMAIN_向上选择>:
{
    send,+{up}
    return
}

<XLMAIN_向下选择>:
{
    send,+{down}
    return
}


<XLMAIN_定位空单元格>:
{
    Excel_Selection()
    XLMAIN_定位对象(4)
    objRelease(excel)
    return
}

<XLMAIN_定位任意格式>:
{
    Excel_Selection()
    XLMAIN_定位对象(-4172)
    objRelease(excel)
    return
}

<XLMAIN_定位验证条件全部>:
{
    Excel_Selection()
    XLMAIN_定位对象(-4174)
    objRelease(excel)
    return
}

<XLMAIN_定位注释>:
{
    Excel_Selection()
    XLMAIN_定位对象(-4144)
    objRelease(excel)
    return
}



<XLMAIN_定位常量全部>:
{
    Excel_Selection()
    XLMAIN_定位公式变量(2,23)
    objRelease(excel)
    return
}


<XLMAIN_定位公式全部>:
{
    Excel_Selection()
    XLMAIN_定位公式变量(-4123,23)
    objRelease(excel)
    return
}


<XLMAIN_定位已用区域最末单元格>:
{
    Excel_Selection()
    XLMAIN_定位对象(11)
    objRelease(excel)
    return
}


<XLMAIN_定位相同格式>:
{
    Excel_Selection()
    XLMAIN_定位对象(-4173)
    objRelease(excel)
    return
}


<XLMAIN_定位验证条件相同>:
{
    Excel_Selection()
    XLMAIN_定位对象(-4175)
    objRelease(excel)
    return
}


<XLMAIN_定位可见>:
{
    Excel_Selection()
    XLMAIN_定位对象(12)
    objRelease(excel)
    return
}




XLMAIN_定位对象(value)
{
    Selection.SpecialCells(value).Select
    return
}

XLMAIN_定位公式变量(value,indicate)
{
    Selection.SpecialCells(value,indicate).Select
    return
}

;过滤
<XLMAIN_自动过滤开启>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.AutoFilterMode
        excel.ActiveSheet.AutoFilterMode := False
    Else
        excel.Selection.AutoFilter
    ;XLMIAN_获取活动工作表边界()
    ;excel.ActiveSheet.Range("A1" , XLMAIN_ColToChar(lLastColumn) . "1").Select
    ;msgbox,%range%
    ;excel.Application.Dialogs(447).Show(fid,excel.ActiveCell.Value)
    objrelease(excel)
    return
}

<XLMAIN_过滤打开筛选对话框>:
{
    Excel_ActiveSheet()
    address:=excel.ActiveSheet.AutoFilter.Range.Address
    StringReplace, address, address, $,,All
    FoundPosSeperate := RegExMatch(address,":")
    StringLeft, parta, address, FoundPosSeperate-1
    StringMid, partb, address, FoundPosSeperate+1 , 50
    ;msgbox,%parta%
    ;msgbox,%partb%
    RegExMatch(parta,"[A-Z]+",ColumnLeftName)
    RegExMatch(parta,"[0-9]+",RowUp)
    fid_first_column:=excel.ActiveSheet.Range(ColumnLeftName "1:" ColumnLeftName "1").Column
    fid:=excel.ActiveCell.Column - fid_first_column + 1
    value:=excel.ActiveCell.Value
    excel.Application.Dialogs(447).Show(fid, value)
    ;msgbox,%RowUp%
    objrelease(excel)
    return
}



<XLMAIN_过滤等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("=",value)
    objrelease(excel)
    return
}

<XLMAIN_过滤小于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("<",value)
    objrelease(excel)
    return
}


<XLMAIN_过滤大于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter(">",value)
    objrelease(excel)
    return
}

<XLMAIN_过滤大于等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter(">=",value)
    objrelease(excel)
    return
}

<XLMAIN_过滤小于等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("<=",value)
    objrelease(excel)
    return
}


<XLMAIN_过滤不等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("<>",value)
    objrelease(excel)
    return
}

<XLMAIN_过滤非空单元格>:
{
    Excel_ActiveSheet()
    ;value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("<>","")
    objrelease(excel)
    return
}

<XLMAIN_过滤空单元格>:
{
    Excel_ActiveSheet()
    ;value:=excel.ActiveCell.Value
    ;msgbox,%value%
    XLMAIN_CustomAutoFilter("=","")
    objrelease(excel)
    return
}

<XLMAIN_过滤包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    value=%value%*
;msgbox,%value%
    XLMAIN_CustomAutoFilter("=*",valve)
    objrelease(excel)
    return
}

<XLMAIN_过滤不包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=%value%*
    XLMAIN_CustomAutoFilter("<>*",valve)
    objrelease(excel)
    return
}

<XLMAIN_过滤开头包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=*%value%
    XLMAIN_CustomAutoFilter("=",valve)
    objrelease(excel)
    return
}

<XLMAIN_过滤末尾包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=%value%*
    XLMAIN_CustomAutoFilter("=",valve)
    objrelease(excel)
    return
}

<XLMAIN_过滤当前列下拉菜单>:
{
    Excel_ActiveSheet()
    ;msgbox,ArithmeticOpr %ArithmeticOpr%
    ;msgbox,CurrentValue %CurrentValue%
    ;msgbox,CriteriaValue %CriteriaValue%
    address:=excel.ActiveSheet.AutoFilter.Range.Address
    StringReplace, address, address, $,,All
    FoundPosSeperate := RegExMatch(address,":")
    StringLeft, parta, address, FoundPosSeperate-1
    StringMid, partb, address, FoundPosSeperate+1 , 50
    ;msgbox,%parta%
    ;msgbox,%partb%
    RegExMatch(parta,"[A-Z]+",ColumnLeftName)
    RegExMatch(parta,"[0-9]+",RowUp)
    ;msgbox,%RowUp%
    column:=excel.ActiveCell.Column
    msgbox,%column%
    excel.ActiveSheet.Cells( RowUp , column ).Activate
    send,!{down}
    objrelease(excel)
    return
}

<XLMAIN_过滤取消当前列>:
{
    Excel_Selection()
    value:=excel.ActiveCell.Value
    XLMAIN_CustomAutoFilter("",valve)
    objrelease(excel)
    return
}

<XLMAIN_过滤取消所有列>:
{
    Excel_Selection()
    If excel.ActiveSheet.FilterMode = True
        excel.ActiveSheet.ShowAllData
    objrelease(excel)
    return
}


XLMAIN_CustomAutoFilter(ArithmeticOpr,CurrentValue)
{
    ;msgbox,ArithmeticOpr %ArithmeticOpr%
    ;msgbox,CurrentValue %CurrentValue%
    CriteriaValue = %ArithmeticOpr%%CurrentValue%
    ;msgbox,CriteriaValue %CriteriaValue%
    address:=excel.ActiveSheet.AutoFilter.Range.Address
    ;msgbox,address %address%
    XLMIAN_获取Range边界(address)
    fid_first_column:=excel.ActiveSheet.Range(ColumnLeftName "1:" ColumnLeftName "1").Column
    fid:=excel.ActiveCell.Column - fid_first_column + 1
    Field:=fid
    ;msgbox,Field %Field%
    Criteria1:=CriteriaValue
    ;msgbox,Criterial %Criterial%
    excel.ActiveSheet.Range("A1").CurrentRegion.AutoFilter(Field,Criteria1)
    return
}




;行指令

<XLMAIN_取消逐行合并>:
{
    Excel_ActiveCell()
    if excel.Selection.Columns.Count > 1
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).unmerge
        }
    }
    objrelease(excel)
    return
}

;by dlt:快捷键实现，可被撤销
<XLMAIN_隐藏选择行>:
{
	send ^9
	return
}


;by dlt:改用快捷键方式，可被撤销
<XLMAIN_删除选择行>:
{
	send ^-
	send !r
	send {Enter}
	return
}



;by dlt:Ctrl+Shift+(
<XLMAIN_隐藏选择行取消>:
{
	send ^+(
	return
}


<XLMAIN_自适应宽度选择行>:
{
    Excel_Selection()
    Selection.EntireRow.AutoFit
    objrelease(excel)
    return
}

<XLMAIN_选择整行>:
{
    Excel_Selection()
    Selection.EntireRow.Select
    objrelease(excel)
    return
}

<XLMAIN_编辑行宽指定值>:
{
    Excel_Selection()
    Default:=Selection.RowHeight
    InputBox, inputvar,输入行宽,,,,,,,,,%Default%
    ;InputBox, OutputVar Title  ,,,,,,,,,
    Selection.RowHeight:=inputvar
    tooltip,%inputvar%
    objRelease(excel)
    sleep,500
    tooltip,
    return
}

;列指令
<XLMAIN_选择整列>:
{
    Excel_Selection()
    Selection.EntireColumn.Select
    objrelease(excel)
    return
}

<XLMAIN_删除选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.Delete
    objrelease(excel)
    return
}


<XLMAIN_自适应宽度选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.AutoFit
    objrelease(excel)
    return
}

<XLMAIN_隐藏选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.Hidden := True
    objrelease(excel)
    return
}

<XLMAIN_隐藏选择列取消>:
{
    Excel_Selection()
    Selection.EntireColumn.Hidden := False
    objrelease(excel)
    return
}



<XLMAIN_编辑列宽指定值>:
{
    Excel_Selection()
    Default:=Selection.ColumnWidth
    InputBox, inputvar,输入列宽,,,,,,,,,%Default%
    Selection.ColumnWidth:=inputvar
    tooltip,%inputvar%
    objRelease(excel)
    sleep,500
    tooltip,
    return
}



;多行指令
<XLMAIN_逐行合并>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    ;msgbox,%SelectionType%
    if SelectionType=1
        {
            return
        }
    else if SelectionType=2
        {
            excel.Selection.merge
        }
    else if SelectionType=4 ;A1:A4
        {
            Return
        }
    else if SelectionType=16
        {
            rowcount:=excel.selection.rows.count
            Loop, %rowcount%
            {
                address:=excel.selection.rows(A_Index).address
                StringReplace, address, address, $,,All
                ;msgbox,%address%
                FoundPosSeperate := RegExMatch(address,":")
                StringLeft, parta, address, FoundPosSeperate-1
                StringMid, partb, address, FoundPosSeperate+1 , 50
                excel.range(parta ":" partb).merge
            }
        }
    objrelease(excel)
    return


    ; Excel_ActiveCell()
    ; if excel.Selection.Columns.Count > 1
    ; {
    ;     rowcount:=excel.selection.rows.count
    ;     Loop, %rowcount%
    ;     {
    ;         address:=excel.selection.rows(A_Index).address
    ;         StringReplace, address, address, $,,All
    ;         ;msgbox,%address%
    ;         FoundPosSeperate := RegExMatch(address,":")
    ;         StringLeft, parta, address, FoundPosSeperate-1
    ;         StringMid, partb, address, FoundPosSeperate+1 , 50
    ;         excel.range(parta ":" partb).merge
    ;     }
    ; }
    ; objrelease(excel)
    ; return
}

;边框

<XLMAIN_边框下框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    ;msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(9).Weight := 2
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(9).Weight := 2
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(9).LineStyle := 1
            excel.range(address).Borders(9).Weight := 2
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).Borders(9).LineStyle := 1
            excel.range(parta ":" partb).Borders(9).Weight := 2
        }
    }
    objrelease(excel)
    return
}


<XLMAIN_边框上框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    ;msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(8).Weight := 2
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(8).Weight := 2
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(8).LineStyle := 1
            excel.range(address).Borders(8).Weight := 2
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).Borders(8).LineStyle := 1
            excel.range(parta ":" partb).Borders(8).Weight := 2
        }
    }
    objrelease(excel)
    return
}


<XLMAIN_边框左框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(7).Weight := 2
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(7).Weight := 2
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(7).LineStyle := 1
            excel.range(address).Borders(7).Weight := 2
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).Borders(7).LineStyle := 1
            excel.range(parta ":" partb).Borders(7).Weight := 2
        }
    }
    objrelease(excel)
    return
}

<XLMAIN_边框右框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(10).LineStyle := 1
            excel.Selection.Borders(10).Weight := 2
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(10).LineStyle := 1
            excel.Selection.Borders(10).Weight := 2
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(10).LineStyle := 1
            excel.range(address).Borders(10).Weight := 2
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).Borders(10).LineStyle := 1
            excel.range(parta ":" partb).Borders(10).Weight := 2
        }
    }
    objrelease(excel)
    return
}

<XLMAIN_边框无框线>:
{
    Excel_ActiveCell()
    excel.Selection.Borders(7).LineStyle := -4142
    excel.Selection.Borders(8).LineStyle := -4142
    excel.Selection.Borders(9).LineStyle := -4142
    excel.Selection.Borders(10).LineStyle := -4142
    excel.Selection.Borders(11).LineStyle :=-4142
    excel.Selection.Borders(12).LineStyle :=-4142
    objrelease(excel)
    return
}

<XLMAIN_边框所有框线>:
{
    Excel_ActiveCell()
    excel.Selection.Borders(7).LineStyle := 1
    excel.Selection.Borders(8).LineStyle := 1
    excel.Selection.Borders(9).LineStyle := 1
    excel.Selection.Borders(10).LineStyle :=1
    excel.Selection.Borders(11).LineStyle :=1
    excel.Selection.Borders(12).LineStyle :=1
    excel.Selection.Borders(7).Weight := 2
    excel.Selection.Borders(8).Weight := 2
    excel.Selection.Borders(9).Weight := 2
    excel.Selection.Borders(10).Weight :=2
    excel.Selection.Borders(11).Weight := 2
    excel.Selection.Borders(12).Weight :=2
    objrelease(excel)
    return
}

<XLMAIN_边框四边框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(10).LineStyle :=1
            excel.Selection.Borders(7).Weight := 2
            excel.Selection.Borders(8).Weight := 2
            excel.Selection.Borders(9).Weight := 2
            excel.Selection.Borders(10).Weight :=2
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(10).LineStyle :=1
            excel.Selection.Borders(7).Weight := 2
            excel.Selection.Borders(8).Weight := 2
            excel.Selection.Borders(9).Weight := 2
            excel.Selection.Borders(10).Weight :=2
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(7).LineStyle := 1
            excel.range(address).Borders(8).LineStyle := 1
            excel.range(address).Borders(9).LineStyle := 1
            excel.range(address).Borders(10).LineStyle :=1
            excel.range(address).Borders(7).Weight := 2
            excel.range(address).Borders(8).Weight := 2
            excel.range(address).Borders(9).Weight := 2
            excel.range(address).Borders(10).Weight :=2
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            excel.range(parta ":" partb).Borders(7).LineStyle := 1
            excel.range(parta ":" partb).Borders(8).LineStyle := 1
            excel.range(parta ":" partb).Borders(9).LineStyle := 1
            excel.range(parta ":" partb).Borders(10).LineStyle :=1
            excel.range(parta ":" partb).Borders(7).Weight := 2
            excel.range(parta ":" partb).Borders(8).Weight := 2
            excel.range(parta ":" partb).Borders(9).Weight := 2
            excel.range(parta ":" partb).Borders(10).Weight :=2
        }
    }
    objrelease(excel)
    return
}



<XLMAIN_边框四边粗匣框线>:
{
    Excel_ActiveCell()
    XLMAIN_GetSelectionType()
    XLMAIN_GetSelectionInfo()
    ;msgbox,%SelectionType%
    if SelectionType=1
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(10).LineStyle :=1
            excel.Selection.Borders(7).Weight := -4138
            excel.Selection.Borders(8).Weight := -4138
            excel.Selection.Borders(9).Weight := -4138
            excel.Selection.Borders(10).Weight :=-4138
        }
    else if SelectionType=2
        {
            excel.Selection.Borders(7).LineStyle := 1
            excel.Selection.Borders(8).LineStyle := 1
            excel.Selection.Borders(9).LineStyle := 1
            excel.Selection.Borders(10).LineStyle :=1
            excel.Selection.Borders(7).Weight := -4138
            excel.Selection.Borders(8).Weight := -4138
            excel.Selection.Borders(9).Weight := -4138
            excel.Selection.Borders(10).Weight :=-4138
        }
    else if SelectionType=4 ;A1:A4
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            excel.range(address).Borders(7).LineStyle := 1
            excel.range(address).Borders(8).LineStyle := 1
            excel.range(address).Borders(9).LineStyle := 1
            excel.range(address).Borders(10).LineStyle :=1
            excel.range(address).Borders(7).Weight := -4138
            excel.range(address).Borders(8).Weight := -4138
            excel.range(address).Borders(9).Weight := -4138
            excel.range(address).Borders(10).Weight :=-4138
        }
    }
    else if SelectionType=16
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
            ;msgbox,%address%
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50

            excel.range(parta ":" partb).Borders(7).LineStyle := 1
            excel.range(parta ":" partb).Borders(8).LineStyle := 1
            excel.range(parta ":" partb).Borders(9).LineStyle := 1
            excel.range(parta ":" partb).Borders(10).LineStyle :=1
            excel.range(parta ":" partb).Borders(7).Weight := -4138
            excel.range(parta ":" partb).Borders(8).Weight := -4138
            excel.range(parta ":" partb).Borders(9).Weight := -4138
            excel.range(parta ":" partb).Borders(10).Weight :=-4138
        }
    }
    objrelease(excel)
    return
}


<XLMAIN_边框粗匣框线>:
{
    Excel_ActiveCell()
    excel.Selection.Borders(7).LineStyle := 1
    excel.Selection.Borders(8).LineStyle := 1
    excel.Selection.Borders(9).LineStyle := 1
    excel.Selection.Borders(10).LineStyle :=1
    excel.Selection.Borders(7).Weight := -4138
    excel.Selection.Borders(8).Weight := -4138
    excel.Selection.Borders(9).Weight := -4138
    excel.Selection.Borders(10).Weight :=-4138
    objrelease(excel)
    return
}





<XLMAIN_边框上下框线>:
{
    Excel_ActiveCell()
    excel.Selection.Borders(5).LineStyle := -4142
    excel.Selection.Borders(6).LineStyle := -4142
    excel.Selection.Borders(7).LineStyle := -4142

    excel.Selection.Borders(8).LineStyle := 1
    excel.Selection.Borders(8).ColorIndex := 0
    excel.Selection.Borders(8).TintAndShade := 0
    excel.Selection.Borders(8).Weight := 2


    excel.Selection.Borders(9).LineStyle := 1
    excel.Selection.Borders(9).ColorIndex := 0
    excel.Selection.Borders(9).TintAndShade := 0
    excel.Selection.Borders(9).Weight := 2

    excel.Selection.Borders(10).LineStyle := -4142
    excel.Selection.Borders(11).LineStyle := -4142
    excel.Selection.Borders(12).LineStyle := -4142
    objrelease(excel)
    return
}


;编辑


<XLMAIN_编辑插入新行在前>:
{
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,500
    send,r
    send,{enter}
    return
}

<XLMAIN_编辑插入新行在后>:
{
    send,{down}
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,500
    send,r
    send,{enter}
    return
}

<XLMAIN_编辑插入新列在右>:
{
    send,{right}
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,500
    send,c
    send,{enter}
    return
}

<XLMAIN_编辑插入新列在左>:
{
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,500
    send,c
    send,{enter}
    return
}


<XLMAIN_编辑替换>:
{
    send,!u
    send,fd
    sleep,400
    send,r
    return
}

<XLMAIN_编辑查找>:
{
    send,!h
    send,fd
    sleep,400
    send,f
    return
}

<XLMAIN_Copy_Selection>:
{
	send ^c
	return
}

<XLMAIN_Copy_Row>:
{
	Excel_Selection()
	Selection.EntireRow.Select
	objrelease(excel)
	send ^c
	return
}

<XLMAIN_Copy_Col>:
{
	Excel_Selection()
	Selection.EntireColumn.Select
	objrelease(excel)
	send ^c
	return
}

<XLMAIN_Paste>:
{
	send ^v
	return
}

<XLMAIN_Paste_Select>:
{
	send ^!v
	return
}

<XLMAIN_Color_Font>:
{
	getExcel().Selection.Font.Color := 0x0000FF
	return
}



<XLMAIN_Color_Cell>:
{
	getExcel().Selection.Interior.Color := CellColor
	return
}

<XLMAIN_Color_Menu_Font>:
{
	return
}

<XLMAIN_Color_Menu_Cell>:
{
	return
}

;编辑复制
<XLMAIN_编辑自左侧复制>:
{
    send,{left}
    send,^c
    send,{right}
    send,^v
    return
}

<XLMAIN_逐行编辑自左侧复制>:
{
    Excel_ActiveCell()
    if excel.Selection.Columns.Count = 1
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            send,{left}
            send,^c
            send,{right}
            send,^v
            sleep,500
            send,{down}
        }
    }
    objrelease(excel)
    return
}


<XLMAIN_编辑自右侧复制>:
{
    send,{right}
    send,^c
    send,{left}
    send,^v
    return
}

<XLMAIN_逐行编辑自右侧复制>:
{
    Excel_ActiveCell()
    if excel.Selection.Columns.Count = 1
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            send,{right}
            send,^c
            send,{left}
            send,^v
            sleep,500
            send,{down}
        }
    }
    objrelease(excel)
    return
}


<XLMAIN_编辑自上侧复制>:
{
    send,{up}
    send,^c
    send,{down}
    send,^v
    return
}

<XLMAIN_编辑自下侧复制>:
{
    send,{down}
    send,^c
    send,{up}
    send,^v
    return
}







;定位
<XLMAIN_定位首个单元格>:
{
    send,^{Home}
    return
}


<XLMAIN_定位尾个单元格>:
{
    Excel_Selection()
    excel.Cells(excel.ActiveSheet.Rows.Count, excel.ActiveCell.Column).End(-4162).Activate
    objRelease(excel)
    return
}

<XLMAIN_定位首行>:
{
    Excel_Selection()
    excel.Selection.End(-4159).Select
    objRelease(excel)
return
}


<XLMAIN_定位尾行>:
{
    Excel_Selection()
    excel.Selection.End(-4161).Select
    objRelease(excel)
}

<XLMAIN_定位首列>:
{
    send,^{left}
    return
}


<XLMAIN_定位尾列>:
{
    send,^{Right}
    return
}




;对齐
<XLMAIN_对齐左>:
{
  Excel_Selection()
  Selection.HorizontalAlignment := -4131
  objRelease(excel)
  return
}




<XLMAIN_对齐水平中间>:
{
  Excel_Selection()
  Selection.HorizontalAlignment := -4108
  objRelease(excel)
  return
}




<XLMAIN_对齐右>:
{
  Excel_Selection()
  Selection.HorizontalAlignment := -4152
  objRelease(excel)
  return
}




<XLMAIN_对齐顶>:
{
  Excel_Selection()
  Selection.VerticalAlignment := -4160
  objRelease(excel)
  return
}



<XLMAIN_对齐垂直中间>:
{
  Excel_Selection()
  Selection.VerticalAlignment := -4108
  objRelease(excel)
  return
}




<XLMAIN_对齐底>:
{
  Excel_Selection()
  Selection.VerticalAlignment := -4107
  objRelease(excel)
  return
}


;单元格颜色
<XLMAIN_单元格颜色黑>:
{
  Excel_Selection()
  Selection.Interior.color:= 0x000000
  objRelease(excel)
  return
}





;字体命令
<XLmain_字体缩小>:
{
    Excel_Selection()
    currentFontSize := Selection.Font.Size
    Selection.Font.Size := currentFontSize - 1
    objRelease(excel)
    return
}

<XLmain_字体放大>:
{
    Excel_Selection()
    currentFontSize := Selection.Font.Size
    Selection.Font.Size := currentFontSize + 1
    objRelease(excel)
    return
}

<excel_find>:
    {
        GUI,XLFind:Destroy
        GUI,XLFind:Add,Edit,w200 h20 gXLFind
        GUI,XLFind:Add,Button,w50 x160 center Default,确定
        GUI,XLFind:Show
    return
}





;工作表
<XLMAIN_SheetReName>:
{
	InputBox, NewSheetName ,输入新的工作表名称
	if StrLen(NewSheetName)>0 {
		Excel_ActiveSheet()
		excel.ActiveSheet.Name := NewSheetName
		objRelease(excel)
	}
	return
}

<XLMAIN_工作表删除当前>:
{
Excel_ActiveSheet()
excel.ActiveWindow.SelectedSheets.delete
objRelease(excel)
return
}

<XLMAIN_工作表复制当前>:
{
Excel_ActiveSheet()
After:=excel.ActiveSheet
excel.ActiveSheet.Copy(After)
objRelease(excel)
return
}

<XLMAIN_工作表选择首个>:
{
Excel_ActiveSheet()
excel.Worksheets(1).Select
objRelease(excel)
return
}


<XLMAIN_工作表选择尾个>:
{
Excel_ActiveSheet()
excel.Worksheets(excel.Worksheets.Count).Select
objRelease(excel)
return
}

<XLMAIN_工作表复制对话框>:
{
Excel_ActiveSheet()
excel.Application.Dialogs(283).Show
objRelease(excel)
return
}

<XLMAIN_工作表跳转下一个>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.index = excel.Worksheets.Count
        excel.Worksheets(1).Select
    Else
        excel.ActiveSheet.Next.Select
    objRelease(excel)
    return
}


<XLMAIN_工作表跳转上一个>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.index =1
        excel.Worksheets(excel.Worksheets.Count).Select
    Else
        excel.ActiveSheet.Previous.Select
    objRelease(excel)
    return
}

<XLMAIN_GoTo>:
{
	Excel_ActiveSheet()
	InputBox, Reference , 输入跳转到的位置，如B5/b5：第二列，第5行
	excel.ActiveSheet.Range(Reference).Select
	objRelease(excel)
	return
}

<XLMAIN_SaveAndExit>:
{
	send ^s
	send !{F4}
	return
}

<XLMAIN_DiscardAndExit>:
{
	Excel_GetCom()
	excel.ActiveWorkbook.Saved := true
	excel.Quit
	objRelease(excel)
	return
}


<XLMAIN_工作表新建>:
{
    Excel_ActiveSheet()
    excel.ActiveWorkbook.Sheets.Add
    objRelease(excel)
    return
}


<XLMAIN_工作表移动向后>:
{
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    If excel.ActiveSheet.index < excel.Worksheets.Count - 1
        {
            After :=excel.Sheets(excel.ActiveSheet.index + 2)
            excel.ActiveSheet.Move(After)
        }
    Else
        {
            excel.Sheets(excel.Worksheets.Count).Move(excel.ActiveSheet)
            excel.Sheets(excel.Worksheets.Count).select
        }
    objRelease(excel)
    return
}

<XLMAIN_工作表移动向前>:
{
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    excel.ActiveSheet.Select
    count:=excel.Worksheets.Count
    If excel.ActiveSheet.index = count
        {
        Before:=excel.Sheets(1)
        excel.ActiveSheet.Move(Before)
        }
    Else
        {
        index:=excel.ActiveSheet.index + 1
        After:=excel.Sheets(index)
        excel.ActiveSheet.Move(After)
        }
    objRelease(excel)
    return
}
;填充


<XLMAIN_填充向下>:
{
    Excel_Selection()
    Selection.FillDown
    objRelease(excel)
    return
}


<XLMAIN_填充向上>:
{
    Excel_Selection()
    Selection.FillUp
    objRelease(excel)
    return
}

<XLMAIN_填充向左>:
{
    Excel_Selection()
    Selection.FillLeft
    objRelease(excel)
    return
}

<XLMAIN_填充向右>:
{
    Excel_Selection()
    Selection.FillRight
    objRelease(excel)
    return
}



;===================================================================
;直接获取Excel
getExcel(){
	objRelease(excel)    
	excel := ComObjActive("Excel.Application") ; 创建Excel对象
	return excel
}

Excel_GetCom()
{
    objRelease(excel)    
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    return
}
Excel_ActiveSheet()
{
    objRelease(excel)    
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    Sheet := excel.ActiveSheet ; 当前工作表
    return
}
Excel_ActiveCell()
{
    objRelease(excel)    
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    Cell := excel.ActiveCell ; 当前单元格
    return
}

Excel_Selection()
{
    objRelease(excel)    
    excel := ComObjActive("Excel.Application") ; 创建Excel对象
    Selection:=excel.Selection ;选择对象
    return
}

Excel_Direction(x=0,y=0) {
    objExcel := Excel_GetObj()
    app  := ObjExcel.Application
    cell := app.ActiveCell
    addr := Cell_Address(cell)
    x_new := CharCalc(Addr["x"],x)
    y_new := addr["y"] + y
    If y_new < 1
        y_new := 1
    new := "$" x_new "$" y_new
    app.range(new).Activate
}

Excel_CellActivate(Location){
    objExcel := Excel_GetObj()
    app  := ObjExcel.Application
    app.range(Location).Activate
}

CharCalc(char,count) {
    StringUpper,Char,Char
    SingleChars := []
    NumberChars := []
    ReturnChars := []
    MaxBit := Strlen(char)
    SingleChars[0] := MaxBit
    Loop,Parse,Char
    {
        Pos := MaxBit - A_Index + 1
        SingleChars[Pos] := Asc(A_LoopField)-64
    }
    ; 800 => abcd
    idx := 26
    Loop
    {
        If count >= %idx%
            idx := idx * idx
        Else {
            MaxBit := A_Index
            Break
        }
    }
    NumberChars[0] := MaxBit
    Loop % MaxBit
    {
        Pos := MaxBit - A_index
        NumberChars[Pos+1] := Floor(Count/26**Pos)
        count := Mod(count,26**Pos)
    }
    s := SingleChars[0]
    n := NumberChars[0]
    If s > %n%
        MaxBit := s
    Else
        MaxBit := n
    Pos := 1
    Add := 0
    Loop,% MaxBit
    {
        s := SingleChars[Pos]
        If not strlen(s)
            s := 0
        n := NumberChars[Pos]
        If not strlen(n)
            n := 0
        r := ReturnChars[Pos]
        If not strlen(r)
            r := 0
        sum := s + n + r
        If sum > 26
        {
            sum := sum - 26
            ReturnChars[Pos+1] := 1
        }
        ReturnChars[Pos] := sum
        Pos++
    }
    msg := ""
    For  i , k in ReturnChars
        msg := Chr(k+64) msg
    return msg
}


Cell_Address(cell) {
    addr := []
    OldAddr := Cell.Address()
    Loop,Parse,OldAddr,$
    {
        If not Strlen(A_LoopField)
            Continue
        If Strlen(addr["x"])
            addr["y"] := A_LoopField
        Else
            addr["x"] := A_LoopField
    }
    return addr
}

Excel_GetObj() {
    ControlGet, hwnd, hwnd, , Excel71, ahk_class XLMAIN
    ObjExcel := Excel[hwnd]
    If IsObject(ObjExcel)
        return ObjExcel
    ObjExcel := Acc_ObjectFromWindow(hwnd, -16)
    Excel[hwnd] := ObjExcel

    return ObjExcel
}



XLMAIN_获取Range地址(address)
{
    StringReplace, address, address, $,,All
    return
}

XLMIAN_获取活动工作表边界()
{
    lLastRow := excel.Cells(excel.Rows.Count, 1).End(-4162).Row
    lLastColumnAddress := excel.Cells(1, excel.Columns.Count).End(-4159).Address
    StringReplace, lLastColumnAddress, lLastColumnAddress, $,,All
    RegExMatch(lLastColumnAddress,"[A-Z]+",lLastColumn)
    return
}


<LastColumn>:
{
    Excel_Selection()
    XLMIAN_获取活动工作表边界()
    msgbox,lLastRow %lLastRow% lLastColumn %lLastColumn%
    XLMAIN_GetSelectionType()

    if SelectionType=1
        {
            rng:=excel.Selection
            ;msgbox,rng %rng%
            XLMAIN_GetSelectionInfo()
            ;msgbox,%SelectFirstColumn%%SelectFirstRow% %SelectionLastColumn%%SelectionLastRow%
            ;msgbox,%SelectFirstColumn%%SelectFirstRow%:%SelectFirstColumn%%lLastRow%
            excel.range(SelectionFirstColumn SelectionFirstRow ":" SelectionFirstColumn lLastRow ).Select ;填充列
            rng.AutoFill(excel.selection,9)
            objRelease(excel)
        }
    else if SelectionType=4
        {
            rng:=excel.Selection
            XLMAIN_GetSelectionInfo()

            excel.range(SelectionFirstColumn SelectionFirstRow ":" SelectionFirstColumn lLastRow).Select
            rng.AutoFill(excel.selection,9)
            objRelease(excel)
        }
    Return
}

<LastRow>:
{
    Excel_Selection()

    XLMAIN_GetSelectionType()
    XLMIAN_获取活动工作表边界()
    if SelectionType=1
        {
            rng:=excel.Selection
            XLMAIN_GetSelectionInfo()
            excel.range(SelectionFirstColumn SelectionFirstRow ":" lLastColumn SelectionFirstRow).select
            rng.AutoFill(excel.selection,9)

            objRelease(excel)
        }
    else if SelectionType=2
        {
            rng:=excel.Selection
            XLMAIN_GetSelectionInfo()
            excel.range(SelectionFirstColumn SelectionFirstRow ":" lLastColumn SelectionFirstRow).select
            rng.AutoFill(excel.selection,9)

            objRelease(excel)
        }
    else
        objRelease(excel)
        Return
}


XLMAIN_ColToChar(index)
{
    If(index <= 26)
    {
        return Chr(64+index)
    }
    Else If (index > 26)
    {
        return Chr((index-1)/26+64) . Chr(mod((index - 1),26)+65)
    }
}




XLMIAN_获取Range边界(address)
{

    StringReplace, address, address, $,,All
    FoundPosSeperate := RegExMatch(address,":")
    StringLeft, parta, address, FoundPosSeperate-1
    StringMid, partb, address, FoundPosSeperate+1 , 50
    ;msgbox,%parta%
    ;msgbox,%partb%
    RegExMatch(parta,"[A-Z]+",ColumnLeftName)
    RegExMatch(parta,"[0-9]+",RowUp)
    ;msgbox,ColumnLeftName%ColumnLeftName% RowUp %RowUp%

    RegExMatch(partb,"[A-Z]+",ColumnRightName)
    RegExMatch(partb,"[0-9]+",RowDown)
    return
}

XLMAIN_GetSelectionType()
{
    if excel.Selection.Columns.Count =1 And excel.Selection.Rows.Count =1 ;A1
        {
            SelectionType:=1
        }
    else if excel.Selection.Columns.Count >1 And excel.Selection.Rows.Count =1 ;A1:B1
        {
            SelectionType:=2
        }
    else if excel.Selection.Columns.Count =1 And excel.Selection.Rows.Count >1 ;A1:A2
        {
            SelectionType:=4
        }
    else if excel.Selection.Columns.Count >1 And excel.Selection.Rows.Count >1  ;A1:B2
        {
            SelectionType:=16
        }
    else
        return
}


XLMAIN_GetSelectionInfo()
{
    address:=excel.Selection.Address
    ;msgbox,address %address%
    StringReplace, address, address, $,,All
    ;msgbox,address %address%

    if SelectionType = 1 ;A1
        {
            ;msgbox,SelectionType %SelectionType%
            RegExMatch(address,"[A-Z]+",SelectionFirstColumn)
            RegExMatch(address,"[0-9]+",SelectionFirstRow)
            ;msgbox,SelectionFirstColumn %SelectionFirstColumn%  SelectionFirstRow %SelectionFirstRow%
            SelectionLastColumn:=SelectionFirstColumn
            SelectionLastRow:=SelectionFirstRow

            return
        }
    else if SelectionType = 2 ;A1:B1
        {
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50

            RegExMatch(parta,"[A-Z]+",SelectionFirstColumn)
            RegExMatch(parta,"[0-9]+",SelectionFirstRow)


            RegExMatch(partb,"[A-Z]+",SelectionLastColumn)
            SelectionLastRow:=SelectionFirstRow


        }
    else if SelectionType = 4 ;A1:A2
        {
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50

            RegExMatch(parta,"[A-Z]+",SelectionFirstColumn)
            RegExMatch(parta,"[0-9]+",SelectionFirstRow)

            SelectionLastColumn:=SelectionFirstColumn
            RegExMatch(partb,"[0-9]+",SelectionLastRow)


        }
    else if SelectionType = 16  ;A1:B2
        {
            FoundPosSeperate := RegExMatch(address,":")
            StringLeft, parta, address, FoundPosSeperate-1
            StringMid, partb, address, FoundPosSeperate+1 , 50
            ;msgbox,%parta%
            ;msgbox,%partb%
            RegExMatch(parta,"[A-Z]+",SelectionFirstColumn)
            RegExMatch(parta,"[0-9]+",SelectionFirstRow)
            ;msgbox,ColumnLeftName%ColumnLeftName% RowUp %RowUp%

            RegExMatch(partb,"[A-Z]+",SelectionLastColumn)
            RegExMatch(partb,"[0-9]+",SelectionLastRow)


        }
    else

        return
}

XLFind:
    XLFind()
return

XLFind() {
    ControlGetText, findstring, Edit1, A
    If not Strlen(findstring)
        return
    If RegExMatch(findstring,"^[a-zA-Z]*$")
        Excel_CellActivate(findstring "1")
    Else
        Excel_CellActivate(findstring)
}



<excel_null>:
return

<excel_replace>:
{
    ClipSaved := ClipboardAll

    Send,^c
    ClipWait
    String := Clipboard

    Clipboard := ClipSaved
    ClipSaved =

    GUI,Replace:Destroy
    GUI,Replace:Add,Edit,w400 h300 ,%String%
    GUI,Replace:show

return
}

