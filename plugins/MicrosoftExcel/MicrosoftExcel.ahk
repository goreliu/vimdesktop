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
    global FontColor := -4165632  ;填充字体颜色-默认蓝色
    global CellColor := -16711681 ;填充表格颜色-默认黄色

    vim.SetWin("MicrosoftExcel", "XLMAIN")

    vim.comment("<Insert_Mode_MicrosoftExcel>", "insert模式")
    vim.comment("<Normal_Mode_MicrosoftExcel>", "normal模式")
    vim.comment("<MicrosoftExcel_SheetReName>", "重命名当前工作表名称")
    vim.comment("<MicrosoftExcel_GoTo>", "跳转到指定行列值的表格")
    vim.comment("<MicrosoftExcel_SaveAndExit>", "保存并退出")
    vim.comment("<MicrosoftExcel_DiscardAndExit>", "放弃修改并退出")
    vim.comment("<excel_undo>", "撤销")
    vim.comment("<redo>", "重做")
    vim.comment("<MicrosoftExcel_SaveAndExit>", "保存后退出")
    vim.comment("<MicrosoftExcel_DiscardAndExit>", "不保存退出")
    vim.comment("<MicrosoftExcel_Color_Font>", "设置选中区域字体为上次颜色")
    vim.comment("<MicrosoftExcel_Color_Cell>", "填充选中表格背景为上次颜色")
    vim.comment("<MicrosoftExcel_Color_All>", "同时应用字体颜色、背景颜色")
    vim.comment("<MicrosoftExcel_Color_Menu_Font>", "设置选中区域字体颜色")
    vim.comment("<MicrosoftExcel_Color_Menu_Cell>", "填充选中表格背景颜色")
    vim.comment("<MicrosoftExcel_FocusHome>", "定位到工作表开头")
    vim.comment("<MicrosoftExcel_FocusEnd>", "定位到工作表最后一个单元格")
    vim.comment("<MicrosoftExcel_FocusRowHome>", "定位到当前列首行")
    vim.comment("<MicrosoftExcel_FocusRowEnd>", "定位到当前列尾行")
    vim.comment("<MicrosoftExcel_FocusColHome>", "定位到当前行首列")
    vim.comment("<MicrosoftExcel_FocusColEnd>", "定位到当前行尾列")
    vim.comment("<MicrosoftExcel_FocusAreaLeft>", "定位到当前区域边缘-左")
    vim.comment("<MicrosoftExcel_FocusAreaRight>", "定位到当前区域边缘-右")
    vim.comment("<MicrosoftExcel_FocusAreaUp>", "定位到当前区域边缘-上")
    vim.comment("<MicrosoftExcel_FocusAreaDown>", "定位到当前区域边缘-下")
    vim.comment("<MicrosoftExcel_SelectToAreaLeft>", "选择到当前区域边缘-左")
    vim.comment("<MicrosoftExcel_SelectToAreaRight>", "选择到当前区域边缘-右")
    vim.comment("<MicrosoftExcel_SelectToAreaUp>", "选择到当前区域边缘-上")
    vim.comment("<MicrosoftExcel_SelectToAreaDown>", "选择到当前区域边缘-下")
    vim.comment("<MicrosoftExcel_Delete>", "删除（=Delete键）")
    vim.comment("<MicrosoftExcel_SelectAll>", "选择全部=^a")
    vim.comment("<MicrosoftExcel_Paste_Value>", "粘贴数值")
    vim.comment("<MicrosoftExcel_PageUp>", "向上翻页")
    vim.comment("<MicrosoftExcel_PageDown>", "向下翻页")
    vim.comment("<MicrosoftExcel_MicrosoftExcel_Cut>", "剪切")
    vim.comment("<MicrosoftExcel_Replace>", "替换")
    vim.comment("<MicrosoftExcel_Find>", "查找")
    vim.comment("<Alt_Mode_MicrosoftExcel>", "alt命令模式")

    ;insert模式及快捷键
    vim.mode("insert", "MicrosoftExcel")
    vim.map("<esc>", "<Normal_Mode_MicrosoftExcel>", "MicrosoftExcel")

    ;normal模式及快捷键
    vim.mode("normal", "MicrosoftExcel")
    vim.map("i", "<Insert_Mode_MicrosoftExcel>", "MicrosoftExcel")
    vim.map("<esc>", "<Normal_Mode_MicrosoftExcel>", "MicrosoftExcel")
    vim.map("I", "<Alt_Mode_MicrosoftExcel>", "MicrosoftExcel")

    ;数字计数
    vim.map("1", "<1>", "MicrosoftExcel")
    vim.map("2", "<2>", "MicrosoftExcel")
    vim.map("3", "<3>", "MicrosoftExcel")
    vim.map("4", "<4>", "MicrosoftExcel")
    vim.map("5", "<5>", "MicrosoftExcel")
    vim.map("6", "<6>", "MicrosoftExcel")
    vim.map("7", "<7>", "MicrosoftExcel")
    vim.map("8", "<8>", "MicrosoftExcel")
    vim.map("9", "<9>", "MicrosoftExcel")

    ;撤销与重复
    vim.map("u", "<excel_undo>", "MicrosoftExcel")
    vim.map("<c-r>", "<redo>", "MicrosoftExcel")

    ;Z保存与退出
    vim.map("ZZ", "<MicrosoftExcel_SaveAndExit>", "MicrosoftExcel")
    vim.map("ZQ", "<MicrosoftExcel_DiscardAndExit>", "MicrosoftExcel")

    ;颜色
    vim.map("""", "<MicrosoftExcel_Color_All>", "MicrosoftExcel")
    vim.map("'", "<MicrosoftExcel_Color_Menu_Font>", "MicrosoftExcel")
    vim.map(";", "<MicrosoftExcel_Color_Menu_Cell>", "MicrosoftExcel")

    ;d删除
    vim.map("dd", "<MicrosoftExcel_Delete>", "MicrosoftExcel")
    vim.map("D", "<MicrosoftExcel_Delete>", "MicrosoftExcel")
    vim.map("dr", "<MicrosoftExcel_删除选择行>", "MicrosoftExcel")
    vim.map("dc", "<MicrosoftExcel_删除选择列>", "MicrosoftExcel")
    vim.map("dw", "<MicrosoftExcel_工作表删除当前>", "MicrosoftExcel")

    ;o插入/O插入在右
    vim.map("or", "<MicrosoftExcel_编辑插入新行在前>", "MicrosoftExcel")
    vim.map("oc", "<MicrosoftExcel_编辑插入新列在左>", "MicrosoftExcel")
    vim.map("Or", "<MicrosoftExcel_编辑插入新行在后>", "MicrosoftExcel")
    vim.map("Oc", "<MicrosoftExcel_编辑插入新列在右>", "MicrosoftExcel")
    vim.map("ow", "<MicrosoftExcel_工作表新建>", "MicrosoftExcel")

    ;s选择
    vim.map("sk", "<MicrosoftExcel_SelectToAreaUp>", "MicrosoftExcel")
    vim.map("sj", "<MicrosoftExcel_SelectToAreaDown>", "MicrosoftExcel")
    vim.map("sh", "<MicrosoftExcel_SelectToAreaLeft>", "MicrosoftExcel")
    vim.map("sl", "<MicrosoftExcel_SelectToAreaRight>", "MicrosoftExcel")
    vim.map("sr", "<MicrosoftExcel_选择整行>", "MicrosoftExcel")
    vim.map("sc", "<MicrosoftExcel_选择整列>", "MicrosoftExcel")
    vim.map("sa", "<MicrosoftExcel_SelectAll>", "MicrosoftExcel")

    ;f过滤命令
    vim.map("ff", "<MicrosoftExcel_自动过滤开启>", "MicrosoftExcel")
    vim.map("fl", "<MicrosoftExcel_过滤当前列下拉菜单>", "MicrosoftExcel")
    vim.map("fd", "<MicrosoftExcel_过滤打开筛选对话框>", "MicrosoftExcel")
    vim.map("fo", "<MicrosoftExcel_过滤大于等于当前单元格>", "MicrosoftExcel")
    vim.map("fu", "<MicrosoftExcel_过滤小于等于当前单元格>", "MicrosoftExcel")
    vim.map("f.", "<MicrosoftExcel_过滤非空单元格>", "MicrosoftExcel")
    vim.map("fb", "<MicrosoftExcel_过滤空单元格>", "MicrosoftExcel")

    ;因不区分数值型与文本型以及日期型的问题，以下过滤功能暂不完整
    vim.map("fB", "<MicrosoftExcel_过滤开头包含当前单元格>", "MicrosoftExcel")
    vim.map("fE", "<MicrosoftExcel_过滤末尾包含当前单元格>", "MicrosoftExcel")
    vim.map("fs", "<MicrosoftExcel_过滤等于当前单元格>", "MicrosoftExcel")
    vim.map("f<", "<MicrosoftExcel_过滤小于当前单元格>", "MicrosoftExcel")
    vim.map("f>", "<MicrosoftExcel_过滤大于当前单元格>", "MicrosoftExcel")
    vim.map("fi", "<MicrosoftExcel_过滤包含当前单元格>", "MicrosoftExcel")
    vim.map("fe", "<MicrosoftExcel_过滤不包含当前单元格>", "MicrosoftExcel")

    ;以下过滤功能2013版测试无效
    vim.map("fa", "<MicrosoftExcel_过滤取消当前列>", "MicrosoftExcel")
    vim.map("fA", "<MicrosoftExcel_过滤取消所有列>", "MicrosoftExcel")

    ;p粘贴
    vim.map("p", "<MicrosoftExcel_Paste>", "MicrosoftExcel")
    vim.map("P", "<MicrosoftExcel_Paste_Select>", "MicrosoftExcel")

    ;pv希望以后用代码做，快捷键做会闪一下
    ;vim.map("v", "<MicrosoftExcel_Paste_Value>", "MicrosoftExcel")

    ;space翻页（PageUp）Shiht-space（PageDown）
    vim.map("<space>", "<MicrosoftExcel_PageDown>", "MicrosoftExcel")
    vim.map("<S-space>", "<MicrosoftExcel_PageUp>", "MicrosoftExcel")

    ;x剪切
    vim.map("x", "<MicrosoftExcel_Cut>", "MicrosoftExcel")

    ;y复制
    vim.map("yy", "<MicrosoftExcel_Copy_Selection>", "MicrosoftExcel")
    vim.map("Y", "<MicrosoftExcel_Copy_Selection>", "MicrosoftExcel")
    vim.map("yr", "<MicrosoftExcel_Copy_Row>", "MicrosoftExcel")
    vim.map("yc", "<MicrosoftExcel_Copy_Col>", "MicrosoftExcel")
    vim.map("yh", "<MicrosoftExcel_编辑自左侧复制>", "MicrosoftExcel")
    vim.map("yl", "<MicrosoftExcel_编辑自右侧复制>", "MicrosoftExcel")
    vim.map("yk", "<MicrosoftExcel_编辑自上侧复制>", "MicrosoftExcel")
    vim.map("yj", "<MicrosoftExcel_编辑自下侧复制>", "MicrosoftExcel")
    vim.map("myl", "<MicrosoftExcel_逐行编辑自左侧复制>", "MicrosoftExcel")
    vim.map("myr", "<MicrosoftExcel_逐行编辑自右侧复制>", "MicrosoftExcel")
    vim.map("yw", "<MicrosoftExcel_工作表复制当前>", "MicrosoftExcel")
    vim.map("yW", "<MicrosoftExcel_工作表复制对话框>", "MicrosoftExcel")

    ;上下左右映射
    vim.map("h", "<left>", "MicrosoftExcel")
    vim.map("l", "<right>", "MicrosoftExcel")
    vim.map("k", "<up>", "MicrosoftExcel")
    vim.map("j", "<down>", "MicrosoftExcel")

    ;上下左右选择映射
    vim.map("H", "<MicrosoftExcel_向左选择>", "MicrosoftExcel")
    vim.map("L", "<MicrosoftExcel_向右选择>", "MicrosoftExcel")
    vim.map("K", "<MicrosoftExcel_向上选择>", "MicrosoftExcel")
    vim.map("J", "<MicrosoftExcel_向下选择>", "MicrosoftExcel")

    ;g位置跳转
    vim.map("gg", "<MicrosoftExcel_FocusHome>", "MicrosoftExcel")
    vim.map("G", "<MicrosoftExcel_FocusEnd>", "MicrosoftExcel")
    vim.map("grh", "<MicrosoftExcel_FocusRowHome>", "MicrosoftExcel")
    vim.map("gre", "<MicrosoftExcel_FocusRowEnd>", "MicrosoftExcel")
    vim.map("gch", "<MicrosoftExcel_FocusColHome>", "MicrosoftExcel")
    vim.map("gce", "<MicrosoftExcel_FocusColEnd>", "MicrosoftExcel")
    vim.map("gk", "<MicrosoftExcel_FocusAreaUp>", "MicrosoftExcel")
    vim.map("gj", "<MicrosoftExcel_FocusAreaDown>", "MicrosoftExcel")
    vim.map("gh", "<MicrosoftExcel_FocusAreaLeft>", "MicrosoftExcel")
    vim.map("gl", "<MicrosoftExcel_FocusAreaRight>", "MicrosoftExcel")
    vim.map("gwh", "<MicrosoftExcel_工作表选择首个>", "MicrosoftExcel")
    vim.map("gwe", "<MicrosoftExcel_工作表选择尾个>", "MicrosoftExcel")
    vim.map("gt", "<MicrosoftExcel_工作表跳转下一个>", "MicrosoftExcel")
    vim.map("gT", "<MicrosoftExcel_工作表跳转上一个>", "MicrosoftExcel")
    vim.map("go", "<MicrosoftExcel_GoTo>", "MicrosoftExcel")

    ;F填充
    vim.map("Fk", "<MicrosoftExcel_填充向上>", "MicrosoftExcel")
    vim.map("Fj", "<MicrosoftExcel_填充向下>", "MicrosoftExcel")
    vim.map("Fh", "<MicrosoftExcel_填充向左>", "MicrosoftExcel")
    vim.map("Fl", "<MicrosoftExcel_填充向右>", "MicrosoftExcel")

    ;r重命名/替换
    vim.map("rr", "<MicrosoftExcel_Replace>", "MicrosoftExcel")
    vim.map("R", "<MicrosoftExcel_Replace>", "MicrosoftExcel")
    vim.map("rw", "<MicrosoftExcel_SheetReName>", "MicrosoftExcel")

    ;/查找
    vim.map("/", "<MicrosoftExcel_Find>", "MicrosoftExcel")

    ;w宽高/W指定值
    vim.map("wr", "<MicrosoftExcel_自适应宽度选择行>", "MicrosoftExcel")
    vim.map("wc", "<MicrosoftExcel_自适应宽度选择列>", "MicrosoftExcel")
    vim.map("Wr", "<MicrosoftExcel_编辑行宽指定值>", "MicrosoftExcel")
    vim.map("Wc", "<MicrosoftExcel_编辑列宽指定值>", "MicrosoftExcel")

    ;工作表

    vim.map(">w", "<MicrosoftExcel_工作表移动向后>", "MicrosoftExcel")
    vim.map("<w", "<MicrosoftExcel_工作表移动向前>", "MicrosoftExcel")

    ;:字体颜色命令

    ;;单元格颜色命令

    ;%页面设置命令

    ;^设置格式命令

    ;@视图指令

    ;-横向线颜色命令

    ;|纵向ActiveSheet.线颜色指令

    ;`字体命令
    vim.map("<S-,>", "<XLmain_字体放大>", "MicrosoftExcel")
    vim.map("<S-.>", "<XLmain_字体缩小>", "MicrosoftExcel")

    ;(名称
    vim.map("<S-9>n", "<MicrosoftExcel_名称工作簿定义>", "MicrosoftExcel")
    vim.map("<S-9>N", "<MicrosoftExcel_名称当前工作表定义>", "MicrosoftExcel")


    ;编辑

    ;行指令
    ;vim.map("rh", "<MicrosoftExcel_隐藏选择行>", "MicrosoftExcel")
    ;vim.map("rH", "<MicrosoftExcel_隐藏选择行取消>", "MicrosoftExcel")

    ;行填充作用不明显
    ;vim.map("rf", "<MicrosoftExcel_行填充>", "MicrosoftExcel")

    ;列指令
    ;vim.map("ch", "<MicrosoftExcel_隐藏选择列>", "MicrosoftExcel")
    ;vim.map("cH", "<MicrosoftExcel_隐藏选择列取消>", "MicrosoftExcel")

    ;vim.map("e", "<MicrosoftExcel_编辑行宽变窄>", "MicrosoftExcel")
    ;vim.map("E", "<MicrosoftExcel_编辑行宽变宽>", "MicrosoftExcel")
    ;vim.map("q", "<MicrosoftExcel_编辑列宽变窄>", "MicrosoftExcel")
    ;vim.map("Q", "<MicrosoftExcel_编辑列宽变宽>", "MicrosoftExcel")

    ;m多区域逐行处理
    ;vim.map("mr", "<MicrosoftExcel_逐行合并>", "MicrosoftExcel")
    ;vim.map("mbd", "<MicrosoftExcel_逐行边框下框线>", "MicrosoftExcel")
    ;vim.map("mbu", "<MicrosoftExcel_逐行边框上框线>", "MicrosoftExcel")
    ;vim.map("mbs", "<MicrosoftExcel_逐行边框外侧框线>", "MicrosoftExcel")
    ;vim.map("mbt", "<MicrosoftExcel_逐行边框粗匣框线>", "MicrosoftExcel")
    ;vim.map("mR", "<MicrosoftExcel_取消逐行合并>", "MicrosoftExcel")

    ;测试
    ;vim.map("t5", "<XLMIAN_获取活动工作表边界>", "MicrosoftExcel")
    vim.map("t1", "<LastRow>", "MicrosoftExcel")
    vim.map("t2", "<LastColumn>", "MicrosoftExcel")

    vim.BeforeActionDo("MicrosoftExcel_BeforeActionDo",  "MicrosoftExcel")
return

;Action 如要跳转，请使用查找功能/

MicrosoftExcel_BeforeActionDo()
{
    ControlGetFocus, ctrl, AHK_CLASS XLMAIN

    If RegExMatch(ctrl, "EXCEL61")
        Return True
    return False
}

<Normal_Mode_MicrosoftExcel>:
    Send, {esc}
    vim.Mode("normal", "MicrosoftExcel")
    getExcel().Application.StatusBar := "NORMAL"
return

<Insert_Mode_MicrosoftExcel>:
    vim.Mode("insert","MicrosoftExcel")

    ;插入模式下使用由Excel接管状态栏
    getExcel().Application.StatusBar := blank
return

<Alt_Mode_MicrosoftExcel>:
    vim.Mode("insert","MicrosoftExcel")

    ;插入模式下使用由Excel接管状态栏
    getExcel().Application.StatusBar := blank
    {
        send {alt}
        return
    }
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


;d删除
<MicrosoftExcel_Delete>:
{
    send,{Del}
    return
}

;by dlt:改用快捷键方式，可被撤销
<MicrosoftExcel_删除选择行>:
{
    send ^-
    send !r
    send {Enter}
    return
}

<MicrosoftExcel_删除选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.Delete
    objrelease(excel)
    return
}

<MicrosoftExcel_工作表删除当前>:
{
    Excel_ActiveSheet()
    excel.ActiveWindow.SelectedSheets.delete
    ;objRelease(excel)
    return
}

;o插入
<MicrosoftExcel_编辑插入新行在前>:
{
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,5
    send,r
    send,{enter}
    return
}

<MicrosoftExcel_编辑插入新列在左>:
{
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,5
    send,c
    send,{enter}
    return
}

<MicrosoftExcel_工作表新建>:
{
    Excel_ActiveSheet()
    getExcel().ActiveWorkbook.Sheets.Add
    ;objRelease(excel)
    return
}


;s选择
<MicrosoftExcel_SelectToAreaUp>:
{
    send,^+{Up}
    return
}

<MicrosoftExcel_SelectToAreaDown>:
{
    send,^+{Down}
    return
}

<MicrosoftExcel_SelectToAreaLeft>:
{
    send,^+{Left}
    return
}

<MicrosoftExcel_SelectToAreaRight>:
{
    send,^+{Right}
    return
}

<MicrosoftExcel_选择整行>:
{
    Excel_Selection()
    Selection.EntireRow.Select
    objrelease(excel)
    return
}

<MicrosoftExcel_选择整列>:
{
    Excel_Selection()
    Selection.EntireColumn.Select
    objrelease(excel)
    return
}

<MicrosoftExcel_SelectAll>:
{
    send,^a
    return
}

;space翻页
<MicrosoftExcel_PageDown>:
{
    send,{PgDn}
    return
}

<MicrosoftExcel_PageUp>:
{
    send,{PgUp}
    return
}

;x剪切
<MicrosoftExcel_Cut>:
{
    send,^x
    return
}

;r置换
<MicrosoftExcel_Replace>:
{
    send,^h
    return
}

;/查找
<MicrosoftExcel_Find>:
{
    send,^f
    return
}

;控制
<MicrosoftExcel_向左选择>:
{
    send,+{left}
    return
}


<MicrosoftExcel_向右选择>:
{
    send,+{right}
    return
}

<MicrosoftExcel_向上选择>:
{
    send,+{up}
    return
}

<MicrosoftExcel_向下选择>:
{
    send,+{down}
    return
}

<MicrosoftExcel_名称工作簿定义>:
{
    Excel_Selection()
    InputBox, OutputVar ,输入名称
    If ErrorLevel
        Return
    inputbox, comments ,输入注释
    If ErrorLevel
        Return
    address:=Selection.address
    Name:=OutputVar
    RefersToR1C1:=address
    excel.ActiveWorkbook.Names.Add(Name,RefersToR1C1)
    ActiveWorkbook.Names(OutputVar).Comment := "comments"
    ;objRelease(excel)
    return
}

<MicrosoftExcel_名称当前工作表定义>:
{
    Excel_Selection()
    InputBox, OutputVar ,输入名称
    If ErrorLevel
        Return
    inputbox, comments ,输入注释
    If ErrorLevel
        Return
    address:=Selection.address
    Name:=OutputVar
    RefersToR1C1:=address
    excel.ActiveSheet.Names.Add(Name,RefersToR1C1)
    ActiveSheet.Names(OutputVar).Comment := "comments"
    ;objRelease(excel)
    return
}

<MicrosoftExcel_定位空单元格>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(4)
    ;objRelease(excel)
    return
}

<MicrosoftExcel_定位任意格式>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(-4172)
    ;objRelease(excel)
    return
}

<MicrosoftExcel_定位验证条件全部>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(-4174)
    ;objRelease(excel)
    return
}

<MicrosoftExcel_定位注释>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(-4144)
    ;objRelease(excel)
    return
}



<MicrosoftExcel_定位常量全部>:
{
    Excel_Selection()
    MicrosoftExcel_定位公式变量(2,23)
    ;objRelease(excel)
    return
}


<MicrosoftExcel_定位公式全部>:
{
    Excel_Selection()
    MicrosoftExcel_定位公式变量(-4123,23)
    ;objRelease(excel)
    return
}


<MicrosoftExcel_定位已用区域最末单元格>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(11)
    ;objRelease(excel)
    return
}


<MicrosoftExcel_定位相同格式>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(-4173)
    ;objRelease(excel)
    return
}


<MicrosoftExcel_定位验证条件相同>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(-4175)
    ;objRelease(excel)
    return
}


<MicrosoftExcel_定位可见>:
{
    Excel_Selection()
    MicrosoftExcel_定位对象(12)
    ;objRelease(excel)
    return
}




MicrosoftExcel_定位对象(value)
{
    Selection.SpecialCells(value).Select
    return
}

MicrosoftExcel_定位公式变量(value,indicate)
{
    Selection.SpecialCells(value,indicate).Select
    return
}

;过滤
<MicrosoftExcel_自动过滤开启>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.AutoFilterMode
        excel.ActiveSheet.AutoFilterMode := False
    Else
        excel.Selection.AutoFilter
    ;XLMIAN_获取活动工作表边界()
    ;excel.ActiveSheet.Range("A1" , MicrosoftExcel_ColToChar(lLastColumn) . "1").Select
    ;msgbox,%range%
    ;excel.Application.Dialogs(447).Show(fid,excel.ActiveCell.Value)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤打开筛选对话框>:
{
    Excel_ActiveSheet()
    address:=excel.ActiveSheet.AutoFilter.Range.Address
    StringReplace, address, address, $,,All
    FoundPosSeperate := RegExMatch(address,":")
    StringLeft, parta, address, FoundPosSeperate-1
    StringMid, partb, address, FoundPosSeperate+1 , 50
    RegExMatch(parta,"[A-Z]+",ColumnLeftName)
    RegExMatch(parta,"[0-9]+",RowUp)
    fid_first_column:=excel.ActiveSheet.Range(ColumnLeftName "1:" ColumnLeftName "1").Column
    fid:=excel.ActiveCell.Column - fid_first_column + 1
    value:=excel.ActiveCell.Value
    excel.Application.Dialogs(447).Show(fid, value)
    objrelease(excel)
    return
}



<MicrosoftExcel_过滤等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("=",value)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤小于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("<",value)
    objrelease(excel)
    return
}


<MicrosoftExcel_过滤大于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter(">",value)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤大于等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter(">=",value)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤小于等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("<=",value)
    objrelease(excel)
    return
}


<MicrosoftExcel_过滤不等于当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("<>",value)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤非空单元格>:
{
    Excel_ActiveSheet()
    ;value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("<>","")
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤空单元格>:
{
    Excel_ActiveSheet()
    ;value:=excel.ActiveCell.Value
    ;msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("=","")
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    value=%value%*
    msgbox,%value%
    MicrosoftExcel_CustomAutoFilter("=*",valve)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤不包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=%value%*
    MicrosoftExcel_CustomAutoFilter("<>*",valve)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤开头包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=*%value%
    MicrosoftExcel_CustomAutoFilter("=",valve)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤末尾包含当前单元格>:
{
    Excel_ActiveSheet()
    value:=excel.ActiveCell.Value
    ;msgbox,%value%
    value=%value%*
    MicrosoftExcel_CustomAutoFilter("=",valve)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤当前列下拉菜单>:
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
    ;msgbox,%column%
    excel.ActiveSheet.Cells( RowUp , column ).Activate
    send,!{down}
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤取消当前列>:
{
    Excel_Selection()
    value:=excel.ActiveCell.Value
    MicrosoftExcel_CustomAutoFilter("",valve)
    objrelease(excel)
    return
}

<MicrosoftExcel_过滤取消所有列>:
{
    Excel_Selection()
    If excel.ActiveSheet.FilterMode = True
        excel.ActiveSheet.ShowAllData
    objrelease(excel)
    return
}


MicrosoftExcel_CustomAutoFilter(ArithmeticOpr,CurrentValue)
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

<MicrosoftExcel_取消逐行合并>:
{
    Excel_ActiveCell()
    if excel.Selection.Columns.Count > 1
    {
        rowcount:=excel.selection.rows.count
        Loop, %rowcount%
        {
            address:=excel.selection.rows(A_Index).address
            StringReplace, address, address, $,,All
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
<MicrosoftExcel_隐藏选择行>:
{
    send ^9
    return
}

;by dlt:Ctrl+Shift+(
<MicrosoftExcel_隐藏选择行取消>:
{
    send ^+(
    return
}

<MicrosoftExcel_自适应宽度选择行>:
{
    Excel_Selection()
    Selection.EntireRow.AutoFit
    objrelease(excel)
    return
}

<MicrosoftExcel_编辑行宽指定值>:
{
    Excel_Selection()
    Default:=Selection.RowHeight
    InputBox, inputvar,输入行宽,,,,,,,,,%Default%
    If ErrorLevel
        Return
    ;InputBox, OutputVar Title  ,,,,,,,,,
    Selection.RowHeight:=inputvar
    tooltip,%inputvar%
    ;objRelease(excel)
    sleep,500
    tooltip,
    return
}

;列指令

<MicrosoftExcel_自适应宽度选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.AutoFit
    objrelease(excel)
    return
}

<MicrosoftExcel_隐藏选择列>:
{
    Excel_Selection()
    Selection.EntireColumn.Hidden := True
    objrelease(excel)
    return
}

<MicrosoftExcel_隐藏选择列取消>:
{
    Excel_Selection()
    Selection.EntireColumn.Hidden := False
    objrelease(excel)
    return
}



<MicrosoftExcel_编辑列宽指定值>:
{
    Excel_Selection()
    Default:=Selection.ColumnWidth
    InputBox, inputvar,输入列宽,,,,,,,,,%Default%
    If ErrorLevel
        Return
    Selection.ColumnWidth:=inputvar
    tooltip,%inputvar%
    ;objRelease(excel)
    sleep,500
    tooltip,
    return
}



;多行指令
<MicrosoftExcel_逐行合并>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
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

<MicrosoftExcel_边框下框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
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


<MicrosoftExcel_边框上框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
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


<MicrosoftExcel_边框左框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
    ;msgbox,%SelectionType%
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

<MicrosoftExcel_边框右框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
    ;msgbox,%SelectionType%
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

<MicrosoftExcel_边框无框线>:
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

<MicrosoftExcel_边框所有框线>:
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

<MicrosoftExcel_边框四边框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
    ;msgbox,%SelectionType%
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

<MicrosoftExcel_边框四边粗匣框线>:
{
    Excel_ActiveCell()
    MicrosoftExcel_GetSelectionType()
    MicrosoftExcel_GetSelectionInfo()
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

<MicrosoftExcel_边框粗匣框线>:
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

<MicrosoftExcel_边框上下框线>:
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

<MicrosoftExcel_编辑插入新行在后>:
{
    send,{down}
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,5
    send,r
    send,{enter}
    return
}

<MicrosoftExcel_编辑插入新列在右>:
{
    send,{right}
    send,{AppsKey}
    send,i
    send,{enter}
    sleep,5
    send,c
    send,{enter}
    return
}

<MicrosoftExcel_Copy_Selection>:
{
    send ^c
    return
}

<MicrosoftExcel_Copy_Row>:
{
    Excel_Selection()
    Selection.EntireRow.Select
    objrelease(excel)
    send ^c
    return
}

<MicrosoftExcel_Copy_Col>:
{
    Excel_Selection()
    Selection.EntireColumn.Select
    objrelease(excel)
    send ^c
    return
}

<MicrosoftExcel_Paste>:
{
    send ^v
    return
}

<MicrosoftExcel_Paste_Select>:
{
    send ^!v
    return
}

<MicrosoftExcel_Paste_Value>:
{
    send ^!v!v{enter}
    return
}

<MicrosoftExcel_Color_Font>:
{
    getExcel().Selection.Font.Color := FontColor
    return
}



<MicrosoftExcel_Color_Cell>:
{
    getExcel().Selection.Interior.Color := CellColor
    return
}

<MicrosoftExcel_Color_All>:
{
    getExcel().Selection.Font.Color := FontColor
    getExcel().Selection.Interior.Color := CellColor
    return
}

<MicrosoftExcel_Color_Menu_Font>:
{
    InputColor(color)

    if color = null
        return
    if color = Transparent
    {
        MsgBox 字体颜色不支持透明色
        return
    }

    FontColor := ToBGR(color)
    getExcel().Selection.Font.Color := FontColor
    return
}

<MicrosoftExcel_Color_Menu_Cell>:
{
    InputColor(color)

    if color = null
        return

    if color = Transparent
    {
        getExcel().Selection.Interior.Pattern := -4142
        return
    }

    CellColor := ToBGR(color)
    getExcel().Selection.Interior.Color := CellColor
    return
}

;编辑复制
<MicrosoftExcel_编辑自左侧复制>:
{
    send,{left}
    send,^c
    send,{right}
    send,^v
    return
}

<MicrosoftExcel_逐行编辑自左侧复制>:
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


<MicrosoftExcel_编辑自右侧复制>:
{
    send,{right}
    send,^c
    send,{left}
    send,^v
    return
}

<MicrosoftExcel_逐行编辑自右侧复制>:
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


<MicrosoftExcel_编辑自上侧复制>:
{
    send,{up}
    send,^c
    send,{down}
    send,^v
    return
}

<MicrosoftExcel_编辑自下侧复制>:
{
    send,{down}
    send,^c
    send,{up}
    send,^v
    return
}

;定位
<MicrosoftExcel_FocusHome>:
{
    send,^{Home}
    return
}

<MicrosoftExcel_FocusEnd>:
{
    send ^{End}
    return
}

; 模拟输入9个Ctrl+Up,差不多能到行首了
<MicrosoftExcel_FocusRowHome>:
{
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    send ^{Up}
    return
}

; 模拟输入9个Ctrl+Down，差不多能到尾行了
<MicrosoftExcel_FocusRowEnd>:
{
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    send ^{Down}
    return
}

; 快捷键Home可直接定位到首列
<MicrosoftExcel_FocusColHome>:
{
    send,{Home}
    return
}

; 貌似没有快捷键直接定位到尾列--同时该功能貌似没什么作用...
<MicrosoftExcel_FocusColEnd>:
{
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    send,^{Right}
    return
}

<MicrosoftExcel_FocusAreaUp>:
{
    send,^{Up}
    return
}

<MicrosoftExcel_FocusAreaDown>:
{
    send,^{Down}
    return
}

<MicrosoftExcel_FocusAreaLeft>:
{
    send,^{Left}
    return
}

<MicrosoftExcel_FocusAreaRight>:
{
    send,^{Right}
    return
}

;对齐
<MicrosoftExcel_对齐左>:
{
    Excel_Selection()
    Selection.HorizontalAlignment := -4131
    ;objRelease(excel)
    return
}

<MicrosoftExcel_对齐水平中间>:
{
    Excel_Selection()
    Selection.HorizontalAlignment := -4108
    ;objRelease(excel)
    return
}

<MicrosoftExcel_对齐右>:
{
    Excel_Selection()
    Selection.HorizontalAlignment := -4152
    ;objRelease(excel)
    return
}

<MicrosoftExcel_对齐顶>:
{
    Excel_Selection()
    Selection.VerticalAlignment := -4160
    ;objRelease(excel)
    return
}

<MicrosoftExcel_对齐垂直中间>:
{
    Excel_Selection()
    Selection.VerticalAlignment := -4108
    ;objRelease(excel)
    return
}

<MicrosoftExcel_对齐底>:
{
    Excel_Selection()
    Selection.VerticalAlignment := -4107
    ;objRelease(excel)
    return
}

;单元格颜色
<MicrosoftExcel_单元格颜色黑>:
{
    Excel_Selection()
    Selection.Interior.color:= 0x000000
    ;objRelease(excel)
    return
}

;字体命令
<XLmain_字体缩小>:
{
    Excel_Selection()
    currentFontSize := Selection.Font.Size
    Selection.Font.Size := currentFontSize - 1
    ;objRelease(excel)
    return
}

<XLmain_字体放大>:
{
    Excel_Selection()
    currentFontSize := Selection.Font.Size
    Selection.Font.Size := currentFontSize + 1
    ;objRelease(excel)
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
<MicrosoftExcel_SheetReName>:
{
    InputBox, NewSheetName ,输入新的工作表名称
    If ErrorLevel
        Return
    if StrLen(NewSheetName) > 0
    {
        Excel_ActiveSheet()
        excel.ActiveSheet.Name := NewSheetName
        ;objRelease(excel)
    }
    return
}

<MicrosoftExcel_工作表复制当前>:
{
    Excel_ActiveSheet()
    After:=excel.ActiveSheet
    excel.ActiveSheet.Copy(After)
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表选择首个>:
{
    Excel_ActiveSheet()
    excel.Worksheets(1).Select
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表选择尾个>:
{
    Excel_ActiveSheet()
    excel.Worksheets(excel.Worksheets.Count).Select
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表复制对话框>:
{
    Excel_ActiveSheet()
    excel.Application.Dialogs(283).Show
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表跳转下一个>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.index = excel.Worksheets.Count
        excel.Worksheets(1).Select
    Else
        excel.ActiveSheet.Next.Select
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表跳转上一个>:
{
    Excel_ActiveSheet()
    If excel.ActiveSheet.index =1
        excel.Worksheets(excel.Worksheets.Count).Select
    Else
        excel.ActiveSheet.Previous.Select
    ;objRelease(excel)
    return
}

<MicrosoftExcel_GoTo>:
{
    Excel_ActiveSheet()
    InputBox, Reference , 输入跳转到的位置，如B5/b5：第二列，第5行
    If ErrorLevel
        Return
    excel.ActiveSheet.Range(Reference).Select
    ;objRelease(excel)
    return
}

<MicrosoftExcel_SaveAndExit>:
{
    send ^s
    send !{F4}
    return
}

<MicrosoftExcel_DiscardAndExit>:
{
    getExcel().ActiveWorkbook.Saved := true
    getExcel().Quit
    return
}

<MicrosoftExcel_工作表移动向后>:
{
    If excel.ActiveSheet.index < excel.Worksheets.Count - 1
    {
        After :=excel.Sheets(excel.ActiveSheet.index + 2)
        getExcel().ActiveSheet.Move(After)
    }
    Else
    {
        getExcel().Sheets(excel.Worksheets.Count).Move(excel.ActiveSheet)
        getExcel().Sheets(excel.Worksheets.Count).select
    }
    ;objRelease(excel)
    return
}

<MicrosoftExcel_工作表移动向前>:
{
    excel := getExcel()
    getExcel().ActiveSheet.Select
    count:=getExcel().Worksheets.Count
    If getExcel().ActiveSheet.index = count
    {
        Before:=getExcel().Sheets(1)
        getExcel().ActiveSheet.Move(Before)
    }
    Else
    {
        index:=getExcel().ActiveSheet.index + 1
        After:=getExcel().Sheets(index)
        getExcel().ActiveSheet.Move(After)
    }
    ;objRelease(excel)
    return
}

;填充

<MicrosoftExcel_填充向下>:
{
    Excel_Selection()
    Selection.FillDown
    ;objRelease(excel)
    return
}

<MicrosoftExcel_填充向上>:
{
    Excel_Selection()
    Selection.FillUp
    ;objRelease(excel)
    return
}

<MicrosoftExcel_填充向左>:
{
    Excel_Selection()
    Selection.FillLeft
    ;objRelease(excel)
    return
}

<MicrosoftExcel_填充向右>:
{
    Excel_Selection()
    Selection.FillRight
    ;objRelease(excel)
    return
}

;===================================================================
;直接获取Excel
getExcel()
{
    ;objRelease(excel)

    if (excel.version <> "")
    {
        excel := ComObjCreate("Excel.Application") ; 创建Excel对象
    }

    return excel
}

Excel_ActiveSheet()
{
    ;objRelease(excel)
    Sheet := getExcel().ActiveSheet ; 当前工作表
    return
}

Excel_ActiveCell()
{
    ;objRelease(excel)
    ;excel := ComObjCreate("Excel.Application") ; 创建Excel对象
    Cell := getExcel().ActiveCell ; 当前单元格
    return
}

Excel_Selection()
{
    ;objRelease(excel)
    ;excel := ComObjCreate("Excel.Application") ; 创建Excel对象
    Selection:=getExcel().Selection ;选择对象
    return
}

Excel_Direction(x=0, y=0)
{
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

CharCalc(char,count)
{
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

Cell_Address(cell)
{
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

Excel_GetObj()
{
    ControlGet, hwnd, hwnd, , Excel71, ahk_class MicrosoftExcel
    ObjExcel := Excel[hwnd]
    If IsObject(ObjExcel)
        return ObjExcel
    ObjExcel := Acc_ObjectFromWindow(hwnd, -16)
    Excel[hwnd] := ObjExcel

    return ObjExcel
}

MicrosoftExcel_获取Range地址(address)
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
    MicrosoftExcel_GetSelectionType()

    if SelectionType = 1
    {
        rng:=excel.Selection
        ;msgbox,rng %rng%
        MicrosoftExcel_GetSelectionInfo()
        ;msgbox,%SelectFirstColumn%%SelectFirstRow% %SelectionLastColumn%%SelectionLastRow%
        ;msgbox,%SelectFirstColumn%%SelectFirstRow%:%SelectFirstColumn%%lLastRow%
        excel.range(SelectionFirstColumn SelectionFirstRow ":" SelectionFirstColumn lLastRow ).Select ;填充列
        rng.AutoFill(excel.selection,9)
        ;objRelease(excel)
    }
    else if SelectionType = 4
    {
        rng:=excel.Selection
        MicrosoftExcel_GetSelectionInfo()

        excel.range(SelectionFirstColumn SelectionFirstRow ":" SelectionFirstColumn lLastRow).Select
        rng.AutoFill(excel.selection,9)
        ;objRelease(excel)
    }
    Return
}

<LastRow>:
{
    Excel_Selection()

    MicrosoftExcel_GetSelectionType()
    XLMIAN_获取活动工作表边界()
    if SelectionType=1
    {
        rng:=excel.Selection
        MicrosoftExcel_GetSelectionInfo()
        excel.range(SelectionFirstColumn SelectionFirstRow ":" lLastColumn SelectionFirstRow).select
        rng.AutoFill(excel.selection,9)

        ;objRelease(excel)
    }
    else if SelectionType=2
    {
        rng:=excel.Selection
        MicrosoftExcel_GetSelectionInfo()
        excel.range(SelectionFirstColumn SelectionFirstRow ":" lLastColumn SelectionFirstRow).select
        rng.AutoFill(excel.selection,9)

        ;objRelease(excel)
    }
    else
        ;objRelease(excel)
        Return
}

MicrosoftExcel_ColToChar(index)
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
    RegExMatch(parta,"[A-Z]+",ColumnLeftName)
    RegExMatch(parta,"[0-9]+",RowUp)
    ;msgbox,ColumnLeftName%ColumnLeftName% RowUp %RowUp%

    RegExMatch(partb,"[A-Z]+",ColumnRightName)
    RegExMatch(partb,"[0-9]+",RowDown)
    return
}

MicrosoftExcel_GetSelectionType()
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

MicrosoftExcel_GetSelectionInfo()
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

XLFind()
{
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

#Include %A_ScriptDir%\plugins\MicrosoftExcel\InputColor.ahk
