unit oge04;

interface

uses System.Collections.Generic;

type
  Graph = Dictionary<(char, char), integer>;
  PathResult = (integer, List<char>);

function Dijkstra(graph: Graph; startNode, endNode: char; excludeNodes: HashSet<char>): PathResult;
function GenerateRandomGraph(minEdges: integer): Graph;
function FindValidPath(graph: Graph; start, via, finish: char; minNodes: integer): (integer, string);
function GenerateTasksOge04(count: integer): List<(string, Dictionary<string, integer>, string)>;

implementation

function Dijkstra(graph: Graph; startNode, endNode: char; excludeNodes: HashSet<char>): PathResult;
begin
  var allNodes := new HashSet<char>();
  foreach var edge in graph.Keys do
  begin
    allNodes.Add(edge.Item1);
    allNodes.Add(edge.Item2);
  end;
  
  var nodes := new HashSet<char>(allNodes);
  nodes.ExceptWith(excludeNodes);
  
  if not nodes.Contains(startNode) or not nodes.Contains(endNode) then
  begin
    Result := (integer.MaxValue, new List<char>());
    exit;
  end;

  var distances := new Dictionary<char, integer>();
  var previous := new Dictionary<char, char>();
  var unvisited := new HashSet<char>(nodes);
  
  foreach var node in nodes do
    distances[node] := integer.MaxValue;
  distances[startNode] := 0;
  
  while unvisited.Count > 0 do
  begin
    var current := ' ';
    var minDist := integer.MaxValue;
    foreach var node in unvisited do
      if distances[node] < minDist then
      begin
        minDist := distances[node];
        current := node;
      end;
    
    if (current = ' ') or (minDist = integer.MaxValue) then break;
    if current = endNode then break;
    unvisited.Remove(current);
    
    // Находим только реальных соседей
    var neighbors := new HashSet<char>();
    foreach var edge in graph.Keys do
    begin
      if (edge.Item1 = current) and not excludeNodes.Contains(edge.Item2) then 
        neighbors.Add(edge.Item2);
      if (edge.Item2 = current) and not excludeNodes.Contains(edge.Item1) then 
        neighbors.Add(edge.Item1);
    end;
    
    foreach var neighbor in neighbors do
    begin
      var edge := (current, neighbor);
      var weight := graph.ContainsKey(edge) ? graph[edge] : graph[(neighbor, current)];
      
      var alt := distances[current] + weight;
      if alt < distances[neighbor] then
      begin
        distances[neighbor] := alt;
        previous[neighbor] := current;
      end;
    end;
  end;
  
  // Построение пути
  if not previous.ContainsKey(endNode) then
  begin
    Result := (integer.MaxValue, new List<char>());
    exit;
  end;
  
  var path := new List<char>();
  var temp := endNode;
  var maxSteps := nodes.Count;
  while (temp <> startNode) and (maxSteps > 0) do
  begin
    path.Add(temp);
    temp := previous[temp];
    maxSteps -= 1;
  end;
  
  if maxSteps <= 0 then
  begin
    Result := (integer.MaxValue, new List<char>());
    exit;
  end;
  
  path.Add(startNode);
  path.Reverse();
  Result := (distances[endNode], path);
end;

function GenerateRandomGraph(minEdges: integer): Graph;
begin
  var graph := new Dictionary<(char, char), integer>();
  var nodes := Arr('A', 'B', 'C', 'D', 'E');
  
  // Сначала создаем минимальное связное дерево
  for var i := 1 to nodes.Length - 1 do
    graph.Add((nodes[0], nodes[i]), Random(1, 10));
  
  // Добавляем дополнительные ребра
  while graph.Count < minEdges do
  begin
    var i := Random(nodes.Length);
    var j := Random(nodes.Length);
    if (i <> j) and not graph.ContainsKey((nodes[i], nodes[j])) and not graph.ContainsKey((nodes[j], nodes[i])) then
      graph.Add((nodes[i], nodes[j]), Random(1, 10));
  end;
  
  Result := graph;
end;

function FindValidPath(graph: Graph; start, via, finish: char; minNodes: integer): (integer, string);
begin
  // Ищем путь от start до via, исключая finish
  var excludeFirstLeg := new HashSet<char>();
  excludeFirstLeg.Add(finish);
  var (dist1, path1) := Dijkstra(graph, start, via, excludeFirstLeg);  
  
  if dist1 = integer.MaxValue then
  begin
    Result := (integer.MaxValue, 'Нет пути из ' + start + ' в ' + via + ' без прохождения через ' + finish);
    exit;
  end;
  
  // Ищем путь от via до finish, исключая узлы из первого пути (кроме via)
  var excludeSecondLeg := new HashSet<char>(path1);
  excludeSecondLeg.Remove(via);  
  var (dist2, path2) := Dijkstra(graph, via, finish, excludeSecondLeg);  
  
  if dist2 = integer.MaxValue then
  begin
    Result := (integer.MaxValue, 'Нет пути из ' + via + ' в ' + finish + ' с учетом ограничений');
    exit;
  end;
  
  var fullPath := new List<char>(path1);
  fullPath.RemoveAt(fullPath.Count - 1);
  fullPath.AddRange(path2);
  var totalDist := dist1 + dist2;
  
  // Проверяем минимальное количество узлов
  if fullPath.Count >= minNodes then
    Result := (totalDist, string.Join(' → ', fullPath))
  else
    Result := (integer.MaxValue, 'Путь содержит только ' + fullPath.Count + ' пункта(ов)');
end;

function GenerateTasksOge04(count: integer): List<(string, Dictionary<string, integer>, string)>;
begin
  Result := new List<(string, Dictionary<string, integer>, string)>();
  var minNodes := 4; // Минимальное количество пунктов в пути
  var nodes := Arr('A', 'B', 'C', 'D', 'E');
    
  var i := 1;
  while i <= count do
  begin
    // Выбираем случайные и различные точки
    var shuffled := nodes.OrderBy(x -> Random()).ToList();
    var start := shuffled[0];
    var finish := shuffled[1];
    var via := shuffled[2];
    
    // Генерируем граф с достаточным количеством ребер
    var graph := GenerateRandomGraph(Random(7, 9));
    
    // Пытаемся найти валидный путь
    var attempts := 0;
    var (distance, path) := FindValidPath(graph, start, via, finish, minNodes);    
    while (distance = integer.MaxValue) and (attempts < 20) do
    begin      
      graph := GenerateRandomGraph(Random(7, 9));      
      (distance, path) := FindValidPath(graph, start, via, finish, minNodes);      
      attempts += 1;
    end;
    
    // Формируем таблицу связности
    var table := new Dictionary<string, integer>();
    foreach var edge in graph do
      table.Add(edge.Key.Item1 + '-' + edge.Key.Item2, edge.Value);
    
    // Формируем текст задачи
    var taskText := 'Между населёнными пунктами A, B, C, D, E построены дороги, ' + 
                   'протяжённость которых приведена в таблице. Найти кратчайший путь ' + 
                   'из пункта ' + start + ' в пункт ' + finish + ' через пункт ' + via + 
                   '.';
    
    // Формируем ответ    
    if distance <> integer.MaxValue then
    begin
      // var answer := distance + ' - ' + path;      
      var answer := distance.ToString();
      Result.Add((taskText, table, answer));
      i += 1;
    end;
  end;
end;

end.