$devicetable = @{}

Class query {
    [String]$HostName
    [String]$IPv4
    [String]$OS
    [String]$Description
    

    query ([string]$computer){
        $this.HostName = $computer
        $this.IPv4 = (Test-connection $computer -count 1).IPV4Address.IPAddressToString
        $this.OS   = gwmi win32_OperatingSystem -ComputerName $computer | select -ExpandProperty Caption
        $this.Description = "None"
    }   
}



Function Add-Entry ($param) {
    If (Test-Connection -count 1 -Quiet $param) {
        $new = [query]::new($param)
        $devicetable[$new.HostName] = $new
    }Else{
        Write-Host "Device Not Found" -ForegroundColor Yellow
   }
}


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '694,480'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 670
$DataGridView1.height            = 280
$DataGridView1.location          = New-Object System.Drawing.Point(9,142)
$DataGridView1.Anchor            = 'top,right,bottom,left'

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Query and Add Item"
$Button1.width                   = 141
$Button1.height                  = 25
$Button1.location                = New-Object System.Drawing.Point(13,93)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 210
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(163,96)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($DataGridView1,$Button1,$TextBox1))



#endregion

#gui events {
function gridClick(){
$rowIndex = $datagridview1.CurrentRow.Index
$columnIndex = $datagridview1.CurrentCell.ColumnIndex
#Write-Host $rowIndex
#Write-Host $columnIndex 
#Write-Host $datagridview1.Rows[$rowIndex].Cells[0].value
Write-Host $datagridview1.Rows[$rowIndex].Cells[$columnIndex].value}


function set-grid {
$array = New-Object System.Collections.ArrayList
$process = $devicetable.Values
$array.AddRange($process)

$dataGridview1.DataSource = $array

$Datagridview1.Columns | ForEach-Object{
    $_.AutoSizeMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::AllCells
}
$form.refresh()
}

$button1.add_Click({
Add-Entry $TextBox1.Text
Set-Grid
})

$DataGridView1.Add_CellMouseClick({ gridClick })

#endregion events }

#endregion GUI }


#Write your logic code here
Set-Grid
[void]$Form.ShowDialog()