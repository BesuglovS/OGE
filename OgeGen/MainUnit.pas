unit MainUnit;

interface

uses System, System.Drawing, System.Windows.Forms,
  System.IO, Microsoft.Office.Interop.Word,
  oge01, oge02, oge03;

type
  MainForm = class(Form)
    procedure MainForm_Load(sender: Object; e: EventArgs);
    procedure browseSaveFolder_Click(sender: Object; e: EventArgs);
    procedure Save_Click(sender: Object; e: EventArgs);
  {$region FormDesigner}
  internal
    {$resource MainUnit.MainForm.resources}
    task03Count: NumericUpDown;
    label3: &Label;
    task02Count: NumericUpDown;
    label2: &Label;
    task01Count: NumericUpDown;
    label1: &Label;
    groupBox2: GroupBox;
    varsCount: NumericUpDown;
    groupBox3: GroupBox;
    browseSaveFolder: Button;
    SaveFilename: TextBox;
    label5: &Label;
    SaveFolder: TextBox;
    label4: &Label;
    Save: Button;
    groupBox1: GroupBox;
    {$include MainUnit.MainForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;

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
    
  var wordApp := new ApplicationClass();
  wordApp.Visible := false;
  var wordDoc: _Document := wordApp.Documents.Add();
  
  wordDoc.PageSetup.LeftMargin := wordApp.CentimetersToPoints(1);
  wordDoc.PageSetup.RightMargin := wordApp.CentimetersToPoints(1);
  wordDoc.PageSetup.TopMargin := wordApp.CentimetersToPoints(1);
  wordDoc.PageSetup.BottomMargin := wordApp.CentimetersToPoints(1);
  
  for var varNum := 0 to varCount - 1 do
  begin
    var p := wordDoc.Paragraphs.Add();
    p.Range.Text := 'Вариант № ' + (varNum + 1).ToString;
    p.Range.Font.Size := 18;
    p.Range.Font.Bold := 1;
    p.Range.InsertParagraphAfter();
    
    var taskNum := 1;
    
    for var i := 0 to t01Count - 1 do
    begin
      var p2 := wordDoc.Paragraphs.Add();
      p2.Range.Text := 'Задание № ' + taskNum.ToString + ' (01)';
      p2.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p2.Range.Font.Size := 16;
      p2.Range.Font.Bold := 1;
      p2.Range.InsertParagraphAfter();
      
      var p3 := wordDoc.Paragraphs.Add();
      p3.Range.Text := tasks01[varNum * t01Count + i][0];
      p3.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p3.Range.Font.Size := 14;
      p3.Range.Font.Bold := 0;
      p3.Range.InsertParagraphAfter();
      taskNum += 1;
    end;
    
    for var i := 0 to t02Count - 1 do
    begin
      var p2 := wordDoc.Paragraphs.Add();
      p2.Range.Text := 'Задание № ' + taskNum.ToString + ' (02)';
      p2.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p2.Range.Font.Size := 16;
      p2.Range.Font.Bold := 1;
      p2.Range.InsertParagraphAfter();
      
      var p3 := wordDoc.Paragraphs.Add();
      p3.Range.Text := tasks02[varNum * t02Count + i][0];
      p3.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p3.Range.Font.Size := 14;
      p3.Range.Font.Bold := 0;
      p3.Range.InsertParagraphAfter();
      taskNum += 1;
    end;
    
    for var i := 0 to t03Count - 1 do
    begin
      var p2 := wordDoc.Paragraphs.Add();
      p2.Range.Text := 'Задание № ' + taskNum.ToString + ' (03)';
      p2.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p2.Range.Font.Size := 16;
      p2.Range.Font.Bold := 1;
      p2.Range.InsertParagraphAfter();
      
      var p3 := wordDoc.Paragraphs.Add();
      p3.Range.Text := tasks03[varNum * t03Count + i][0];
      p3.Format.Alignment := WdParagraphAlignment.wdAlignParagraphJustify;
      p3.Range.Font.Size := 14;
      p3.Range.Font.Bold := 0;
      p3.Range.InsertParagraphAfter();
      taskNum += 1;
    end;
    
    var br: object := WdBreakType.wdPageBreak;
    wordDoc.Words.Last.InsertBreak(br);
  end;
  
  var p2 := wordDoc.Paragraphs.Add();
  p2.Range.Text := 'ОТВЕТЫ';
  p2.Format.Alignment := WdParagraphAlignment.wdAlignParagraphCenter;
  p2.Range.Font.Size := 28;
  p2.Range.Font.Bold := 0;
  p2.Range.InsertParagraphAfter();
  
  var range := wordDoc.Paragraphs.Last.Range;    
  var table := wordDoc.Tables.Add(range, varCount + 1, varLength + 1);
  table.Borders.Enable := 1;
  
  table.Cell(1, 1).Range.Text := 'Вариант';
  table.Cell(1, 1).Range.Font.Size := 12;
  var taskStr := '01';
  for var i := 1 to varLength do
  begin
    table.Cell(1, 1 + i).Range.Font.Size := 12;
    table.Cell(1, 1 + i).Range.Text := $'№ {i} ({taskStr})';
    if i = t01Count then taskStr := '02';
    if i = t01Count + t02Count then taskStr := '03';
  end;
  
  for var i := 1 to varCount do
  begin
    table.Cell(1 + i, 1).Range.Font.Size := 12;
    table.Cell(1 + i, 1).Range.Text := i.ToString;
    for var j := 1 to varLength do
    begin
      table.Cell(1 + i, 1 + j).Range.Font.Size := 12;
      if j <= t01Count then
      begin
        var n := j;        
        table.Cell(1 + i, 1 + j).Range.Text := tasks01[(i - 1) * t01Count + n - 1].Item2;        
      end
      else if j <= t01Count + t02Count then
      begin
        var n := j - t01Count;
        table.Cell(1 + i, 1 + j).Range.Text := tasks02[(i - 1) * t02Count + n - 1].Item2;
      end
      else
      begin
        var n := j - t01Count - t02Count;
        table.Cell(1 + i, 1 + j).Range.Text := tasks03[(i - 1) * t03Count + n - 1].Item2;
      end;
    end;
  end;
  
  
  var savepath := SaveFolder.Text;
  var filename := SaveFilename.Text;
  var filePath := Path.Combine(savepath, filename);
  var fileNameObj: object := filePath;
  var formatObj: object := WdSaveFormat.wdFormatDocumentDefault;
  wordDoc.SaveAs(fileNameObj, formatObj);
  wordDoc.Close();
  wordApp.Quit();
end;

end.
