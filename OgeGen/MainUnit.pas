{#reference DocumentFormat.OpenXml.dll}

unit MainUnit;

interface

uses System, System.IO, System.Drawing, System.Windows.Forms, 
  DocumentFormat.OpenXml.Packaging,
  DocumentFormat.OpenXml.Wordprocessing,
  oge01, oge02, oge03, oge04;

type
  MainForm = class(Form)
    procedure browseSaveFolder_Click(sender: Object; e: EventArgs);
    procedure MainForm_Load(sender: Object; e: EventArgs);
    procedure Save_Click(sender: Object; e: EventArgs);
  {$region FormDesigner}
  internal
    {$resource MainUnit.MainForm.resources}
    groupBox1: GroupBox;
    task03Count: NumericUpDown;
    label3: &Label;
    task02Count: NumericUpDown;
    label2: &Label;
    task01Count: NumericUpDown;
    label1: &Label;
    groupBox2: GroupBox;
    varsCount: NumericUpDown;
    groupBox3: GroupBox;
    SaveFilename: TextBox;
    label5: &Label;
    browseSaveFolder: Button;
    SaveFolder: TextBox;
    label4: &Label;
    task04Count: NumericUpDown;
    label6: &Label;
    Save: Button;
    {$include MainUnit.MainForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;
  
  wText = DocumentFormat.OpenXml.Wordprocessing.Text;

implementation

procedure MainForm.MainForm_Load(sender: Object; e: EventArgs);
begin
  var desktopPath := Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
  SaveFolder.Text := desktopPath;
end;

procedure MainForm.browseSaveFolder_Click(sender: Object; e: EventArgs);
begin
  var dlg := new FolderBrowserDialog();
  dlg.SelectedPath := SaveFolder.Text;
  dlg.Description := 'Выберите папку';
  dlg.ShowNewFolderButton := true;
  
  if dlg.ShowDialog() = System.Windows.Forms.DialogResult.OK then
  begin
    SaveFolder.Text := dlg.SelectedPath;
  end;
end;

procedure AddPara(b: Body; str: string; fSize: integer; bld: boolean := False; 
  just: string := '');
begin
  var p: Paragraph;
  if just <> '' then
  begin
    var j := new Justification();    
    if just = 'both' then
      j.Val := JustificationValues.Both
    else if just = 'center' then
      j.Val := JustificationValues.Center;
    var pp := new ParagraphProperties(j);
    p := new Paragraph(pp);
  end
  else
    p := new Paragraph();
  // Добавляем параграф с текстом
  var paragraph := b.AppendChild(p);
  var run := paragraph.AppendChild(new Run());    
  var runProperties := new RunProperties();
  if bld then
    runProperties.Bold := new Bold();  
  
  runProperties.FontSize := new FontSize();
  runProperties.FontSize.Val := fSize.ToString; // 28-14; 32-16
  run.AppendChild(runProperties);
  run.AppendChild(new DocumentFormat.OpenXml.Wordprocessing.Text(str));  
end;

function ppCenter(): ParagraphProperties;
begin
  var just := new Justification();
  just.Val := JustificationValues.Center;
  result := new ParagraphProperties(just);
end;

function Cell1cm(): TableCellProperties;
begin
  var tcw := new TableCellWidth();
  tcw.Type := TableWidthUnitValues.Dxa;
  tcw.Width := '567';
  var tcp := new TableCellProperties(tcw);
  result := tcp;  
end;

procedure AddTask04Table(body: Body; d: Dictionary<string, integer>);
begin
  var vertices: array of string := ('A', 'B', 'C', 'D', 'E');
  
  var table := body.AppendChild(new Table());
  var u4: longword := 4;
  var tb := new TopBorder(); tb.Val := BorderValues.Single; tb.Size := u4;
  var bb := new BottomBorder(); bb.Val := BorderValues.Single; bb.Size := u4;
  var lb := new LeftBorder(); lb.Val := BorderValues.Single; lb.Size := u4;
  var rb := new RightBorder(); rb.Val := BorderValues.Single; rb.Size := u4;
  var ihb := new InsideHorizontalBorder(); ihb.Val := BorderValues.Single; ihb.Size := u4;
  var ivb := new InsideVerticalBorder(); ivb.Val := BorderValues.Single; ivb.Size := u4;
  var borders := new TableBorders(tb, bb, lb, rb, ihb, ivb);      
  var tableProperties := new TableProperties();
  tableProperties.Append(borders);
  table.AppendChild(tableProperties);
  
      // Создаем первую строку (заголовки)
  var row := table.AppendChild(new TableRow());
  
      // Пустая ячейка в левом верхнем углу
  row.Append(new TableCell(Cell1cm, new Paragraph(new Run(new wText('')))));
  
      // Заголовки столбцов (вершины)
  for var j := 0 to Length(vertices) - 1 do              
    row.Append(new TableCell(Cell1cm, new Paragraph(ppCenter, new Run(new wText(vertices[j])))));
  
      // Заполняем таблицу связности
  for var k := 0 to Length(vertices) - 1 do
  begin
    row := table.AppendChild(new TableRow());
    
        // Заголовок строки (вершина)
    row.Append(new TableCell(Cell1cm, new Paragraph(ppCenter, new Run(new wText(vertices[k])))));
    
        // Заполняем ячейки таблицы
    for var j := 0 to Length(vertices) - 1 do
    begin
      var cell := row.AppendChild(new TableCell(Cell1cm));
      var paragraph := cell.AppendChild(new Paragraph(ppCenter));
      var run := paragraph.AppendChild(new Run());
      var cellText := '';
      
      if k = j then
        cellText := '*' // расстояние от вершины до самой себя
          else
      begin
            // Проверяем наличие ребра в обоих направлениях
        var edge1 := vertices[k] + '-' + vertices[j];
        var edge2 := vertices[j] + '-' + vertices[k];
        
        if d.ContainsKey(edge1) then
          cellText := d[edge1].ToString()
        else if d.ContainsKey(edge2) then
          cellText := d[edge2].ToString()
        else
          cellText := ' '; // если ребра нет
      end;
      
      run.AppendChild(new wText(cellText));
    end;
  end;
end;

function tcp(): TableCellProperties;
begin
  var lm := new LeftMargin(); 
  lm.Width := '170'; lm.Type := TableWidthUnitValues.Dxa;
  var tcp := new TableCellProperties(new TableCellMargin(lm));
  result := tcp;
end;

procedure MainForm.Save_Click(sender: Object; e: EventArgs);
begin
  var varCount := integer(varsCount.Value);
  var t01Count := integer(task01Count.Value);
  var t02Count := integer(task02Count.Value);
  var t03Count := integer(task03Count.Value);  
  var t04Count := integer(task04Count.Value);    
  
  var tasks01 := GenerateTasksOge01(varCount * t01Count);
  var tasks02 := GenerateTasksOge02(varCount * t02Count);
  var tasks03 := GenerateTasksOge03(varCount * t03Count);
  var tasks04 := GenerateTasksOge04(varCount * t04Count);
  
  var savepath := SaveFolder.Text;
  var filename := SaveFilename.Text;
  var filePath := Path.Combine(savepath, filename);
  
  // Создаём документ
  var doc := WordprocessingDocument.Create(
    filePath,
    DocumentFormat.OpenXml.WordprocessingDocumentType.Document);
  
  // Добавляем основную часть
  var mainPart := doc.AddMainDocumentPart();
  mainPart.Document := new Document();
  var body := mainPart.Document.AppendChild(new Body());
  
  // Создаем секцию и устанавливаем поля
  var sectionProperties := new SectionProperties();
  
  // Устанавливаем поля (1 см = 567 твипов)
  var pageMargin := new PageMargin();
  var x: longword := 567;
  var x2: longword := 0;
  pageMargin.Left := x;    // 1 см слева (567 twips = 1 см)
  pageMargin.Right := x;   // 1 см справа
  pageMargin.Top := 567;     // 1 см сверху
  pageMargin.Bottom := 567;  // 1 см снизу
  pageMargin.Header := x2;    // Верхний колонтитул
  pageMargin.Footer := x2;    // Нижний колонтитул
  pageMargin.Gutter := x2;    // Переплетный отступ
  
  sectionProperties.Append(pageMargin);
  body.Append(sectionProperties);
  
  for var varNum := 0 to varCount - 1 do
  begin
    var taskNum := 1;
    
    AddPara(body, 'Вариант № ' + (varNum + 1).ToString, 36, true);
    
    for var i := 0 to t01Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (01)', 32, true);
      AddPara(body, tasks01[varNum * t01Count + i][0], 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t02Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (02)', 32, true);
      AddPara(body, tasks02[varNum * t02Count + i][0], 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t03Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (03)', 32, true);
      AddPara(body, tasks03[varNum * t03Count + i][0], 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t04Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (04)', 32, true);
      AddPara(body, tasks04[varNum * t04Count + i][0], 28, false, 'both');     
      
      var d := tasks04[varNum * t04Count + i][1];
      
      AddTask04Table(body, d);
      
      
      
      taskNum += 1;
    end;
    
    // Разрыв страницы
    var breakPara := body.AppendChild(new Paragraph());
    var breakRun := breakPara.AppendChild(new Run());
    var br := new Break();
    br.Type := BreakValues.Page;  
    breakRun.AppendChild(br);
  end;
  
  AddPara(body, 'ОТВЕТЫ', 40, true, 'center');
  
  // Создаем таблицу
  var table := new Table();
  
  // Настройки свойств таблицы
  var tw := new TableWidth(); 
  tw.Width := '5000'; tw.Type := TableWidthUnitValues.Pct;  
  var u4: longword := 4;
  var tb := new TopBorder(); tb.Val := BorderValues.Single; tb.Size := u4;
  var bb := new BottomBorder(); bb.Val := BorderValues.Single; bb.Size := u4;
  var lb := new LeftBorder(); lb.Val := BorderValues.Single; lb.Size := u4;
  var rb := new RightBorder(); rb.Val := BorderValues.Single; rb.Size := u4;
  var ihb := new InsideHorizontalBorder(); ihb.Val := BorderValues.Single; ihb.Size := u4;
  var ivb := new InsideVerticalBorder(); ivb.Val := BorderValues.Single; ivb.Size := u4;
  var borders := new TableBorders(tb, bb, lb, rb, ihb, ivb);
  var tableProperties := new TableProperties(tw);
  tableProperties.Append(borders);
  table.AppendChild(tableProperties);
  
  // Создаем строки и ячейки
  var row1 := new TableRow();
    
  var cell1 := new TableCell();  
  cell1.Append(new Paragraph(ppCenter, new Run(new wText('Вариант'))));
  row1.Append(cell1);
  
  var taskNum := 1;
  for var i := 1 to t01Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (01)')))));
    taskNum += 1;
  end;
  for var i := 1 to t02Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (02)')))));
    taskNum += 1;
  end;
  for var i := 1 to t03Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (03)')))));
    taskNum += 1;
  end;
  for var i := 1 to t04Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (04)')))));
    taskNum += 1;
  end;
  table.Append(row1);
  
  for var i := 1 to varCount do
  begin
    var row2 := new TableRow();
    
    row2.Append(new TableCell(new Paragraph(ppCenter, new Run(new wText(i.ToString)))));
    
    for var j := 0 to t01Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks01[(i - 1) * t01Count + j].Item2)))));
    end;
    
    for var j := 0 to t02Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks02[(i - 1) * t02Count + j].Item2)))));
    end;
    
    for var j := 0 to t03Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks03[(i - 1) * t03Count + j].Item2)))));
    end;
    
    for var j := 0 to t04Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks04[(i - 1) * t04Count + j].Item3)))));
    end;
    
    table.Append(row2);
  end;
  
  
  body.Append(table);
  
  // Закрываем документ
  doc.Dispose();
end;

end.
