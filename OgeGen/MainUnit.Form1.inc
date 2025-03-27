procedure InitializeComponent;
    begin
        self.groupBox1 := new System.Windows.Forms.GroupBox();
        self.SuspendLayout();
        // 
        // groupBox1
        // 
        self.groupBox1.Location := new System.Drawing.Point(44, 29);
        self.groupBox1.Name := 'groupBox1';
        self.groupBox1.Size := new System.Drawing.Size(200, 100);
        self.groupBox1.TabIndex := 0;
        self.groupBox1.TabStop := false;
        self.groupBox1.Text := 'groupBox1';
        // 
        // Form1
        // 
        self.ClientSize := new System.Drawing.Size(445, 321);
        self.Controls.Add(self.groupBox1);
        self.Name := 'Form1';
        self.Text := 'Form1';
        self.ResumeLayout(false);
    end;
