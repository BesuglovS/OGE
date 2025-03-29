procedure InitializeComponent;
    begin
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
        self.groupBox1 := new System.Windows.Forms.GroupBox();
        self.task03Count := new System.Windows.Forms.NumericUpDown();
        self.label3 := new System.Windows.Forms.Label();
        self.task02Count := new System.Windows.Forms.NumericUpDown();
        self.label2 := new System.Windows.Forms.Label();
        self.task01Count := new System.Windows.Forms.NumericUpDown();
        self.label1 := new System.Windows.Forms.Label();
        self.groupBox2 := new System.Windows.Forms.GroupBox();
        self.varsCount := new System.Windows.Forms.NumericUpDown();
        self.groupBox3 := new System.Windows.Forms.GroupBox();
        self.SaveFilename := new System.Windows.Forms.TextBox();
        self.label5 := new System.Windows.Forms.Label();
        self.browseSaveFolder := new System.Windows.Forms.Button();
        self.SaveFolder := new System.Windows.Forms.TextBox();
        self.label4 := new System.Windows.Forms.Label();
        self.Save := new System.Windows.Forms.Button();
        self.groupBox1.SuspendLayout();
        (System.ComponentModel.ISupportInitialize(self.task03Count)).BeginInit();
        (System.ComponentModel.ISupportInitialize(self.task02Count)).BeginInit();
        (System.ComponentModel.ISupportInitialize(self.task01Count)).BeginInit();
        self.groupBox2.SuspendLayout();
        (System.ComponentModel.ISupportInitialize(self.varsCount)).BeginInit();
        self.groupBox3.SuspendLayout();
        self.SuspendLayout();
        // 
        // groupBox1
        // 
        self.groupBox1.Controls.Add(self.task03Count);
        self.groupBox1.Controls.Add(self.label3);
        self.groupBox1.Controls.Add(self.task02Count);
        self.groupBox1.Controls.Add(self.label2);
        self.groupBox1.Controls.Add(self.task01Count);
        self.groupBox1.Controls.Add(self.label1);
        self.groupBox1.Location := new System.Drawing.Point(12, 12);
        self.groupBox1.Name := 'groupBox1';
        self.groupBox1.Size := new System.Drawing.Size(191, 159);
        self.groupBox1.TabIndex := 0;
        self.groupBox1.TabStop := false;
        self.groupBox1.Text := 'Количество заданий в варианте';
        // 
        // task03Count
        // 
        self.task03Count.Location := new System.Drawing.Point(6, 122);
        self.task03Count.Name := 'task03Count';
        self.task03Count.Size := new System.Drawing.Size(71, 20);
        self.task03Count.TabIndex := 5;
        self.task03Count.Value := new System.Decimal(new System.Int32[4](2, 0, 0, 0));
        // 
        // label3
        // 
        self.label3.Location := new System.Drawing.Point(6, 102);
        self.label3.Name := 'label3';
        self.label3.Size := new System.Drawing.Size(71, 17);
        self.label3.TabIndex := 4;
        self.label3.Text := 'Задание 03';
        // 
        // task02Count
        // 
        self.task02Count.Location := new System.Drawing.Point(6, 79);
        self.task02Count.Name := 'task02Count';
        self.task02Count.Size := new System.Drawing.Size(71, 20);
        self.task02Count.TabIndex := 3;
        self.task02Count.Value := new System.Decimal(new System.Int32[4](2, 0, 0, 0));
        // 
        // label2
        // 
        self.label2.Location := new System.Drawing.Point(6, 59);
        self.label2.Name := 'label2';
        self.label2.Size := new System.Drawing.Size(71, 17);
        self.label2.TabIndex := 2;
        self.label2.Text := 'Задание 02';
        // 
        // task01Count
        // 
        self.task01Count.Location := new System.Drawing.Point(6, 36);
        self.task01Count.Name := 'task01Count';
        self.task01Count.Size := new System.Drawing.Size(71, 20);
        self.task01Count.TabIndex := 1;
        self.task01Count.Value := new System.Decimal(new System.Int32[4](2, 0, 0, 0));
        // 
        // label1
        // 
        self.label1.Location := new System.Drawing.Point(6, 16);
        self.label1.Name := 'label1';
        self.label1.Size := new System.Drawing.Size(71, 17);
        self.label1.TabIndex := 0;
        self.label1.Text := 'Задание 01';
        // 
        // groupBox2
        // 
        self.groupBox2.Controls.Add(self.varsCount);
        self.groupBox2.Location := new System.Drawing.Point(209, 12);
        self.groupBox2.Name := 'groupBox2';
        self.groupBox2.Size := new System.Drawing.Size(147, 56);
        self.groupBox2.TabIndex := 1;
        self.groupBox2.TabStop := false;
        self.groupBox2.Text := 'Количество вариантов';
        // 
        // varsCount
        // 
        self.varsCount.Location := new System.Drawing.Point(6, 19);
        self.varsCount.Name := 'varsCount';
        self.varsCount.Size := new System.Drawing.Size(71, 20);
        self.varsCount.TabIndex := 6;
        self.varsCount.Value := new System.Decimal(new System.Int32[4](25, 0, 0, 0));
        // 
        // groupBox3
        // 
        self.groupBox3.Controls.Add(self.SaveFilename);
        self.groupBox3.Controls.Add(self.label5);
        self.groupBox3.Controls.Add(self.browseSaveFolder);
        self.groupBox3.Controls.Add(self.SaveFolder);
        self.groupBox3.Controls.Add(self.label4);
        self.groupBox3.Location := new System.Drawing.Point(12, 177);
        self.groupBox3.Name := 'groupBox3';
        self.groupBox3.Size := new System.Drawing.Size(344, 100);
        self.groupBox3.TabIndex := 2;
        self.groupBox3.TabStop := false;
        self.groupBox3.Text := 'Сохранить как...';
        // 
        // SaveFilename
        // 
        self.SaveFilename.Location := new System.Drawing.Point(6, 71);
        self.SaveFilename.Name := 'SaveFilename';
        self.SaveFilename.Size := new System.Drawing.Size(332, 20);
        self.SaveFilename.TabIndex := 9;
        self.SaveFilename.Text := 'ОГЭ.docx';
        // 
        // label5
        // 
        self.label5.Location := new System.Drawing.Point(6, 55);
        self.label5.Name := 'label5';
        self.label5.Size := new System.Drawing.Size(71, 17);
        self.label5.TabIndex := 8;
        self.label5.Text := 'Имя файла';
        // 
        // browseSaveFolder
        // 
        self.browseSaveFolder.Location := new System.Drawing.Point(264, 32);
        self.browseSaveFolder.Name := 'browseSaveFolder';
        self.browseSaveFolder.Size := new System.Drawing.Size(74, 20);
        self.browseSaveFolder.TabIndex := 7;
        self.browseSaveFolder.Text := 'Выбрать...';
        self.browseSaveFolder.UseVisualStyleBackColor := true;
        self.browseSaveFolder.Click += browseSaveFolder_Click;
        // 
        // SaveFolder
        // 
        self.SaveFolder.Location := new System.Drawing.Point(6, 32);
        self.SaveFolder.Name := 'SaveFolder';
        self.SaveFolder.Size := new System.Drawing.Size(252, 20);
        self.SaveFolder.TabIndex := 6;
        // 
        // label4
        // 
        self.label4.Location := new System.Drawing.Point(6, 16);
        self.label4.Name := 'label4';
        self.label4.Size := new System.Drawing.Size(71, 17);
        self.label4.TabIndex := 5;
        self.label4.Text := 'Папка';
        // 
        // Save
        // 
        self.Save.Font := new System.Drawing.Font('Microsoft Sans Serif', 16, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, (System.Byte(204)));
        self.Save.Location := new System.Drawing.Point(209, 74);
        self.Save.Name := 'Save';
        self.Save.Size := new System.Drawing.Size(147, 97);
        self.Save.TabIndex := 3;
        self.Save.Text := 'Сохранить';
        self.Save.UseVisualStyleBackColor := true;
        self.Save.Click += Save_Click;
        // 
        // MainForm
        // 
        self.ClientSize := new System.Drawing.Size(370, 289);
        self.Controls.Add(self.Save);
        self.Controls.Add(self.groupBox3);
        self.Controls.Add(self.groupBox2);
        self.Controls.Add(self.groupBox1);
        self.Icon := (System.Drawing.Icon(resources.GetObject('$this.Icon')));
        self.Name := 'MainForm';
        self.Text := 'Генератор вариантов ОГЭ';
        self.Load += MainForm_Load;
        self.groupBox1.ResumeLayout(false);
        (System.ComponentModel.ISupportInitialize(self.task03Count)).EndInit();
        (System.ComponentModel.ISupportInitialize(self.task02Count)).EndInit();
        (System.ComponentModel.ISupportInitialize(self.task01Count)).EndInit();
        self.groupBox2.ResumeLayout(false);
        (System.ComponentModel.ISupportInitialize(self.varsCount)).EndInit();
        self.groupBox3.ResumeLayout(false);
        self.groupBox3.PerformLayout();
        self.ResumeLayout(false);
    end;
