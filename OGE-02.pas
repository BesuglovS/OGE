type
  TNode = auto class
    Symbol: Char;
    Frequency: Integer;
    Left, Right: TNode;    
  end;
  
  TCodeDictionary = Dictionary<Char, string>;

function BuildFrequencyTable(s: string) := s.EachCount;

function BuildHuffmanTree(FrequencyTable: Dictionary<Char, Integer>): TNode;
begin
  var PriorityQueue := new Queue<TNode>();
  foreach var Key in FrequencyTable.Keys do
  begin
    var Frequency := FrequencyTable[Key];
    PriorityQueue.Enqueue(TNode.Create(Key, Frequency, nil, nil));
  end;
  
  while PriorityQueue.Count > 1 do
  begin
    var Node1 := PriorityQueue.Dequeue;
    var Node2 := PriorityQueue.Dequeue;
    var NewNode := TNode.Create(#0, Node1.Frequency + Node2.Frequency, Node1, Node2);
    PriorityQueue.Enqueue(NewNode);
  end;
  
  Result := PriorityQueue.Dequeue;
end;

procedure GenerateCodes(Node: TNode; const Prefix: string; var Codes: TCodeDictionary);
begin  
  if Node.Symbol <> #0 then
    Codes.Add(Node.Symbol, Prefix)
  else
  begin
    GenerateCodes(Node.Left, Prefix + '0', Codes);
    GenerateCodes(Node.Right, Prefix + '1', Codes);
  end;
end;

function HuffmanEncode(const S: string): TCodeDictionary;
begin
  var FrequencyTable := BuildFrequencyTable(S);
  var HuffmanTree := BuildHuffmanTree(FrequencyTable);
  Result := TCodeDictionary.Create;
  GenerateCodes(HuffmanTree, '', Result);
end;

procedure PrintCodes(const Codes: TCodeDictionary);
begin
  foreach var Pair in Codes do
    Writeln(Pair.Key, ': ', Pair.Value);
end;

function CodesToStringAlpha(const Codes: TCodeDictionary): string;
begin
  var keys := Codes.Keys.Sorted.ToArray;
  var keyStrings := keys.Select(k -> k + ': ' + Codes[k]);
  result := keyStrings.JoinToString(', ');
end;

function EncodeString(s: string; const Codes: TCodeDictionary): string;
begin
  var res := '';
  foreach var let in s do
    res += Codes[let];
  result := res;
end;

begin
  var wds := ReadAllLines('wap_peace.txt', Encoding.UTF8);
  loop 1_000_000 do
    Swap(wds[Random(wds.Length)], wds[Random(wds.Length)]);  
  wds := wds[:1000];
  
  var f := OpenWrite('OGE-02.txt');
  foreach var w in wds do
  begin
    var w2 := w.Distinct.ToArray.Aggregate('', (x, y) -> x + y);
    var code_length := Random(w2.Length + 2, w2.Length + 5);
    while w2.Length < code_length do
    begin
      var lst := ('а'..'я').Where(c -> c not in w2).toArray;
      w2 := w2 + lst[Random(lst.Length)];
    end;
    var Codes := HuffmanEncode(w2);
    var task := 'От разведчика было получено сообщение ';
    task += EncodeString(w, Codes) + '.>';
    task += 'В сообщении зашифрован пароль - последовательность русских букв.>';
    task += 'В коде есть только следующие буквы - ' + CodesToStringAlpha(Codes) + '.>';
    task += 'Расшифруйте пароль и запишите его в ответ.';
    Writeln(f, task, #9, w);
  end;
  f.Close();
  Println('Done!'); 
end.