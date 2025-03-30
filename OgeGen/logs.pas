unit logs;

interface

procedure log(message: string);

implementation

procedure log(message: string);
begin
  // Открываем файл для добавления текста (если файла нет - он создаётся)
  var logFile: Text;
  Assign(logFile, 'logs.txt');
  
  try
    // Пытаемся открыть файл для добавления
    Append(logFile);
  except
    // Если файла нет - создаём новый
    Rewrite(logFile);
  end;
  
  // Записываем сообщение с текущей датой и временем
  Writeln(logFile, DateTime.Now.ToString('yyyy-MM-dd HH:mm:ss') + ' | ' + message);
  
  // Закрываем файл
  Close(logFile);
end;

end.