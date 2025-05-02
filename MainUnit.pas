{#reference DocumentFormat.OpenXml.dll}

unit MainUnit;

interface

uses System, System.IO, System.Drawing, System.Windows.Forms, 
  DocumentFormat.OpenXml.Packaging,
  DocumentFormat.OpenXml.Wordprocessing,
  oge01, oge02, oge03, oge04, oge05, oge06, oge07, oge08,
  oge09, oge10;

type
  MainForm = class(Form)
    procedure browseSaveFolder_Click(sender: Object; e: EventArgs);
    procedure MainForm_Load(sender: Object; e: EventArgs);
    procedure Save_Click(sender: Object; e: EventArgs);
    procedure all1_Click(sender: Object; e: EventArgs);
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
    task05Count: NumericUpDown;
    label7: &Label;
    task06Count: NumericUpDown;
    label8: &Label;
    task07Count: NumericUpDown;
    label9: &Label;
    task08Count: NumericUpDown;
    label10: &Label;
    all1: Button;
    task10Count: NumericUpDown;
    label11: &Label;
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

function tcp(): TableCellProperties;
begin
  var lm := new LeftMargin(); 
  lm.Width := '170'; lm.Type := TableWidthUnitValues.Dxa;
  var tcp := new TableCellProperties(new TableCellMargin(lm));
  result := tcp;
end;

procedure AddPara(b: Body; str: string; fSize: integer; bld: boolean := False; 
  just: string := ''; keep_Next: boolean := false);
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
    if keep_Next then
      pp.KeepNext := new KeepNext();
    p := new Paragraph(pp);
  end
  else
  begin
    var pp := new ParagraphProperties();
    if keep_Next then
      pp.KeepNext := new KeepNext();
    p := new Paragraph(pp);
  end;
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

function ppCenterKn(): ParagraphProperties;
begin
  var just := new Justification();
  just.Val := JustificationValues.Center;
  var pp := new ParagraphProperties(just);
  pp.AppendChild(new KeepNext());
  result := pp;
end;

function Cell1cm(): TableCellProperties;
begin
  var tcw := new TableCellWidth();
  tcw.Type := TableWidthUnitValues.Dxa;
  tcw.Width := '567';
  var tcp := new TableCellProperties(tcw);
  result := tcp;  
end;

function ppsa0(): ParagraphProperties;
begin
  var sbl := new SpacingBetweenLines();
  sbl.After := string('0');
  var ppsa0 := new ParagraphProperties(sbl);
  result := ppsa0; 
end;

function ppsa0Kn(): ParagraphProperties;
begin
  var sbl := new SpacingBetweenLines();
  sbl.After := string('0');
  var ppsa0 := new ParagraphProperties(sbl);
  ppsa0.AppendChild(new KeepNext());
  result := ppsa0; 
end;

function cstr(): TableRowProperties;
begin
  result := new TableRowProperties(
    new CantSplit() // Запрещает разрыв строки таблицы
  );
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
  var row := table.AppendChild(new TableRow(cstr));
  
      // Пустая ячейка в левом верхнем углу
  row.Append(new TableCell(Cell1cm, new Paragraph(ppCenterKn, new Run(new wText('')))));
  
      // Заголовки столбцов (вершины)
  for var j := 0 to Length(vertices) - 1 do              
    row.Append(new TableCell(Cell1cm, new Paragraph(ppCenterKn, new Run(new wText(vertices[j])))));
  
      // Заполняем таблицу связности
  for var k := 0 to Length(vertices) - 1 do
  begin
    row := table.AppendChild(new TableRow(cstr));
    
        // Заголовок строки (вершина)
    row.Append(new TableCell(Cell1cm, new Paragraph(ppCenterKn, new Run(new wText(vertices[k])))));
    
        // Заполняем ячейки таблицы
    for var j := 0 to Length(vertices) - 1 do
    begin
      var cell := row.AppendChild(new TableCell(Cell1cm));
      var paragraph := cell.AppendChild(new Paragraph(ppCenterKn));
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



procedure AddTask06Table(body: Body; progs: List<string>);
begin  
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
  var tl := new TableLayout();
  tl.Type := TableLayoutValues.Fixed;
  tableProperties.Append(tl);
  table.AppendChild(tableProperties);
  
  // Создаем первую строку
  var row1 := new TableRow(cstr);  
  var cell1 := new TableCell();  
  cell1.Append(new Paragraph(ppCenterKn, new Run(new wText('Алгоритмический язык'))));
  row1.Append(cell1);
  var cell2 := new TableCell();  
  cell2.Append(new Paragraph(ppCenterKn, new Run(new wText('Паскаль'))));
  row1.Append(cell2);
  table.Append(row1);
  
  // Создаем вторую строку
  row1 := new TableRow(cstr);  
  cell1 := new TableCell();  
  var taskP := progs[0].Split(#10);
  foreach var p in taskP do
    cell1.Append(tcp, new Paragraph(ppsa0Kn, new Run(new wText(p))));      
  row1.Append(cell1);
  cell2 := new TableCell();  
  taskP := progs[1].Split(#10);
  foreach var p in taskP do
    cell2.Append(tcp, new Paragraph(ppsa0Kn, new Run(new wText(p))));        
  row1.Append(cell2);
  table.Append(row1);
  
  // Создаем третью строку
  row1 := new TableRow(cstr);  
  cell1 := new TableCell();  
  cell1.Append(new Paragraph(ppCenterKn, new Run(new wText('Python'))));
  row1.Append(cell1);
  cell2 := new TableCell();  
  cell2.Append(new Paragraph(ppCenterKn, new Run(new wText('C++'))));
  row1.Append(cell2);
  table.Append(row1);
  
  // Создаем чётвёртую строку
  row1 := new TableRow(cstr);  
  cell1 := new TableCell();  
  taskP := progs[2].Split(#10);
  foreach var p in taskP do
    cell1.Append(tcp, new Paragraph(ppsa0Kn, new Run(new wText(p))));      
  row1.Append(cell1);
  cell2 := new TableCell();  
  taskP := progs[3].Split(#10);
  foreach var p in taskP do
    cell2.Append(tcp, new Paragraph(ppsa0Kn, new Run(new wText(p))));      
  row1.Append(cell2);
  table.Append(row1);
  
  body.Append(table);
end;

procedure AddTask02Table(body: Body; codes: Dictionary<char, string>);
begin  
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
  var tl := new TableLayout();
  tl.Type := TableLayoutValues.Fixed;
  tableProperties.Append(tl);
  table.AppendChild(tableProperties);
  
  // Создаем первую строку
  var row1 := new TableRow(cstr);    
  foreach var k in codes do
  begin
    var cell1 := new TableCell();
    cell1.Append(new Paragraph(ppCenterKn, new Run(new wText(k.Key))));
    row1.Append(cell1);
  end;  
  table.Append(row1);
  
  // Создаем вторую строку
  var row2 := new TableRow(cstr);    
  foreach var k in codes do
  begin
    var cell1 := new TableCell();
    cell1.Append(new Paragraph(ppCenterKn, new Run(new wText(k.Value))));
    row2.Append(cell1);
  end;  
  table.Append(row2);
  
  body.Append(table);
end;

procedure AddTask07Table(body: Body; urlParts: List<(integer, string)>);
begin  
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
  var tl := new TableLayout();
  tl.Type := TableLayoutValues.Fixed;
  tableProperties.Append(tl);
  table.AppendChild(tableProperties);
  
  // Создаем первую строку
  var row1 := new TableRow(cstr);    
  foreach var urlPart in urlParts do
  begin
    var cell1 := new TableCell();
    cell1.Append(new Paragraph(ppCenterKn, new Run(new wText(urlPart.Item1.ToString))));
    row1.Append(cell1);
  end;  
  table.Append(row1);
  
  // Создаем вторую строку
  var row2 := new TableRow(cstr);    
  foreach var urlPart in urlParts do
  begin
    var cell1 := new TableCell();
    cell1.Append(new Paragraph(ppCenterKn, new Run(new wText(urlPart.Item2))));
    row2.Append(cell1);
  end;  
  table.Append(row2);
  
  body.Append(table);
end;

procedure AddTask08Table(body: Body; sets: List<(string, string)>);
begin  
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
  var tl := new TableLayout();
  tl.Type := TableLayoutValues.Fixed;
  tableProperties.Append(tl);
  table.AppendChild(tableProperties);
  
  // Создаем первую строку
  var row1 := new TableRow(cstr);    
  
  var cell1 := new TableCell();
  cell1.Append(new Paragraph(ppCenterKn, new Run(new wText('Запрос'))));
  row1.Append(cell1);
  
  var cell2 := new TableCell();
  cell2.Append(new Paragraph(ppCenterKn, new Run(new wText('Найдено страниц'))));
  row1.Append(cell2);
  
  table.Append(row1);
  
  // Создаем вторую строку
  
  foreach var st in sets do
  begin
    var row2 := new TableRow(cstr);
    
    var c1 := new TableCell();
    c1.Append(tcp, new Paragraph(new Run(new wText(st.Item1))));
    row2.Append(c1);
    
    var c2 := new TableCell();
    c2.Append(new Paragraph(ppCenterKn, new Run(new wText(st.Item2))));
    row2.Append(c2);
    
    table.Append(row2);
  end;  
  
  
  body.Append(table);
end;

function runSize(x: integer): RunProperties;
begin
  var rp := new RunProperties();
  var fs := new FontSize();
  fs.Val := x.ToString;
  rp.AppendChild(fs);
  result := rp;  
end;

procedure AddTask10Table(body: Body; nums: List<(string, string)>);
begin  
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
  var tl := new TableLayout();
  tl.Type := TableLayoutValues.Fixed;
  tableProperties.Append(tl);
  table.AppendChild(tableProperties);
  
  // Создаем первую строку
  var row1 := new TableRow(cstr);    
  
  foreach var num in nums do
  begin
    // cell1
    var cell1 := new TableCell();
    var r1 := new Run(new wText(num[0]));
    r1.RunProperties := runSize(48);
    
    var r2 := new Run(new wText(num[1]));
    var rProperties := new RunProperties();
    var va := new VerticalTextAlignment();
    va.Val := VerticalPositionValues.Subscript;
    rProperties.VerticalTextAlignment := va;
    var fs := new FontSize();
    fs.Val := '48';
    rProperties.AppendChild(fs);
    r2.RunProperties := rProperties;
    
    var p := new Paragraph(ppCenterKn, r1);  
    p.Append(r2);
    cell1.Append(p);
    row1.Append(cell1);
  end;
  
  table.Append(row1);
  
  body.Append(table);
end;




procedure MainForm.Save_Click(sender: Object; e: EventArgs);
begin
  var varCount := integer(varsCount.Value);
  var t01Count := integer(task01Count.Value);
  var t02Count := integer(task02Count.Value);
  var t03Count := integer(task03Count.Value);  
  var t04Count := integer(task04Count.Value);    
  var t05Count := integer(task05Count.Value);    
  var t06Count := integer(task06Count.Value);    
  var t07Count := integer(task07Count.Value);
  var t08Count := integer(task08Count.Value);
  var t10Count := integer(task10Count.Value);
  
  var tasks01 := GenerateTasksOge01(varCount * t01Count);
  var tasks02 := GenerateTasksOge02(varCount * t02Count);
  var tasks03 := GenerateTasksOge03(varCount * t03Count);
  var tasks04 := GenerateTasksOge04(varCount * t04Count);
  var tasks05 := GenerateTasksOge05(varCount * t05Count);
  var tasks06 := GenerateTasksOge06(varCount * t06Count);
  var tasks07 := GenerateTasksOge07(varCount * t07Count);
  var tasks08 := GenerateTasksOge08(varCount * t08Count);
  var tasks10 := GenerateTasksOge10(varCount * t10Count);
  
  var savepath := SaveFolder.Text;
  var fn := SaveFilename.Text.TrimEnd;
  var l5 := '';
  try
    l5 := fn[fn.Length - 4:fn.Length + 1].ToLower;
  except
    on exc: System.Exception do 
      l5 := '';
  end;
  if l5 <> '.docx' then
    fn += '.docx';
  SaveFilename.Text := fn;
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
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (01)', 32, true, '', true);
      var taskP := tasks01[varNum * t01Count + i][0].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t02Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (02)', 32, true, '', true);
      var taskP := tasks02[varNum * t02Count + i][0].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both');      
      
      AddTask02Table(body, tasks02[varNum * t02Count + i][1]);
      
      AddPara(body, tasks02[varNum * t02Count + i][2], 28, false, 'both', true);      
      taskNum += 1;
    end;
    
    for var i := 0 to t03Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (03)', 32, true, '', true);
      var taskP := tasks03[varNum * t03Count + i][0].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t04Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (04)', 32, true, '', true);
      var taskP := tasks04[varNum * t04Count + i][0].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both', true);      
      
      var d := tasks04[varNum * t04Count + i][1];      
      AddTask04Table(body, d);
      
      taskNum += 1;
    end;
    
    for var i := 0 to t05Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (05)', 32, true, '', true);
      var taskP := tasks05[varNum * t05Count + i][0].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t06Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (06)', 32, true, '', true);
      AddPara(body, tasks06[varNum * t06Count + i][0], 28, false, 'both', true);      
      
      AddTask06Table(body, tasks06[varNum * t06Count + i][1]);
      
      var taskP := tasks06[varNum * t06Count + i][2].Split(#10);
      foreach var p in taskP do
        AddPara(body, p, 28, false, 'both');      
      taskNum += 1;
    end;
    
    for var i := 0 to t07Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (07)', 32, true, '', true);
      var taskP := tasks07[varNum * t07Count + i][0].Split(#10);      
      AddPara(body, taskP[0], 28, false, 'both');      
      AddPara(body, taskP[1], 28, false);      
      
      AddTask07Table(body, tasks07[varNum * t05Count + i][1]);
      
      AddPara(body, taskP[2], 28, false);
      taskNum += 1;
    end;
    
    for var i := 0 to t08Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (08)', 32, true, '', true);
      var taskP := tasks08[varNum * t08Count + i][0].Split(#10);      
      AddPara(body, taskP[0], 28, false, 'both');      
      AddPara(body, taskP[1], 28, false);      
      
      AddTask08Table(body, tasks08[varNum * t08Count + i][1]);
      
      AddPara(body, tasks08[varNum * t08Count + i][2], 28, false);
      taskNum += 1;
    end;
    
    for var i := 0 to t10Count - 1 do
    begin
      AddPara(body, 'Задание № ' + taskNum.ToString + ' (10)', 32, true, '', true);
      
      AddTask10Table(body, tasks10[varNum * t10Count + i][1]);
      
      var taskP := tasks10[varNum * t10Count + i][0].Split(#10);      
      AddPara(body, taskP[0], 28, false, 'both');      
      if taskP.Count > 1 then
        AddPara(body, taskP[1], 28, false);      
      
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
  for var i := 1 to t05Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (05)')))));
    taskNum += 1;
  end;  
  for var i := 1 to t06Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (06)')))));
    taskNum += 1;
  end;
  
  for var i := 1 to t07Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (07)')))));
    taskNum += 1;
  end;
  
  for var i := 1 to t08Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (08)')))));
    taskNum += 1;
  end;
  
  for var i := 1 to t10Count do  
  begin
    row1.Append(new TableCell(new Paragraph(ppCenter, new Run(
      new wText($'№ {taskNum} (10)')))));
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
          new wText(tasks02[(i - 1) * t02Count + j].Item4)))));
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
    
    for var j := 0 to t05Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks05[(i - 1) * t05Count + j].Item2)))));
    end;
    
    for var j := 0 to t06Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks06[(i - 1) * t06Count + j].Item4.ToString)))));
    end;
    
    for var j := 0 to t07Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks07[(i - 1) * t07Count + j].Item3.ToString)))));
    end;
    
    for var j := 0 to t08Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks08[(i - 1) * t08Count + j].Item4.ToString)))));
    end;
    
    for var j := 0 to t10Count - 1 do  
    begin
      row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks10[(i - 1) * t10Count + j].Item3.ToString)))));
    end;
    
    table.Append(row2);
  end;
  
  
  body.Append(table);
  
  // Закрываем документ
  doc.Dispose();
end;

procedure MainForm.all1_Click(sender: Object; e: EventArgs);
begin
  task01Count.Value := 1;
  task02Count.Value := 1;
  task03Count.Value := 1;
  task04Count.Value := 1;
  task05Count.Value := 1;
  task06Count.Value := 1;
  task07Count.Value := 1;
  task08Count.Value := 1;
  task10Count.Value := 1;
end;

end.
