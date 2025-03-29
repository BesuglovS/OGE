{#reference DocumentFormat.OpenXml.dll}

Unit MainUnit;

interface

uses System, System.IO, System.Drawing, System.Windows.Forms, 
  DocumentFormat.OpenXml.Packaging,
  DocumentFormat.OpenXml.Wordprocessing,
  oge01, oge02, oge03;

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

procedure MainForm.Save_Click(sender: Object; e: EventArgs);
begin
  var varCount := integer(varsCount.Value);
  var t01Count := integer(task01Count.Value);
  var t02Count := integer(task02Count.Value);
  var t03Count := integer(task03Count.Value);  
  var varLength := t01Count + t02Count + t03Count;
  
  var tasks01 := GenerateTasksOge01(varCount * t01Count);
  var tasks02 := GenerateTasksOge02(varCount * t02Count);
  var tasks03 := GenerateTasksOge03(varCount * t03Count);
  
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
  
  var just := new Justification();
  just.Val := JustificationValues.Center;
  var ppCenter := new ParagraphProperties(just);
  
  
  // Ячейка 1
  var cell1 := new TableCell();  
  cell1.Append(new Paragraph(ppCenter, new Run(new wText('Вариант'))));
  row1.Append(cell1);
  
  var taskStr := '01';
  for var i := 1 to varLength do
  begin
    just := new Justification();
    just.Val := JustificationValues.Center;
    ppCenter := new ParagraphProperties(just);
    
    var cell2 := new TableCell();
    cell2.Append(new Paragraph(ppCenter, new Run(new wText($'№ {i} ({taskStr})'))));
    row1.Append(cell2);
    if i = t01Count then taskStr := '02';
    if i = t01Count + t02Count then taskStr := '03';
  end;
  table.Append(row1);
  
  for var i := 1 to varCount do
  begin
    var row2 := new TableRow();
    
    just := new Justification();
    just.Val := JustificationValues.Center;
    ppCenter := new ParagraphProperties(just);
    
    row2.Append(new TableCell(new Paragraph(ppCenter, new Run(new wText(i.ToString)))));
    
    for var j := 1 to varLength do
    begin
      var lm := new LeftMargin(); 
      lm.Width := '170'; lm.Type := TableWidthUnitValues.Dxa;
      var tcp := new TableCellProperties(new TableCellMargin(lm));
      
      if j <= t01Count then
      begin
        var n := j;
        row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks01[(i - 1) * t01Count + n - 1].Item2)))));        
      end
      else if j <= t01Count + t02Count then
      begin
        var n := j - t01Count;        
        row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks02[(i - 1) * t02Count + n - 1].Item2)))));
      end
      else
      begin
        var n := j - t01Count - t02Count;
        row2.Append(new TableCell(tcp, new Paragraph(new Run(
          new wText(tasks03[(i - 1) * t03Count + n - 1].Item2)))));
      end;
    end;
    table.Append(row2);
  end;
  
  
  body.Append(table);
  
  // Закрываем документ
  doc.Dispose();
end;

end.
