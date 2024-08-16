Add-Type -AssemblyName PresentationCore,PresentationFramework

# Obtener la dirección IP
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" }).IPAddress

# Obtener la dirección MAC
$macAddress = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).MacAddress

# Obtener el gateway predeterminado
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1).NextHop

# Crear el contenido del texto a mostrar
$info = @"
IP Address: $ipAddress
MAC Address: $macAddress
Default Gateway: $gateway
"@

# Crear una ventana flotante
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$form = New-Object Windows.Forms.Form
$form.Text = "Network Information"
$form.Size = New-Object Drawing.Size(300,150)
$form.StartPosition = "Manual"
$form.TopMost = $true
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::Black
$form.TransparencyKey = $form.BackColor

# Posicionar la ventana en la parte superior derecha
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$form.Location = New-Object Drawing.Point(($screenWidth - $form.Width - 10), 10)

$label = New-Object Windows.Forms.Label
$label.Text = $info
$label.AutoSize = $true
$label.ForeColor = [System.Drawing.Color]::White
$label.Font = New-Object Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$label.Location = New-Object Drawing.Point(10,10)

$form.Controls.Add($label)
$form.ShowDialog()
