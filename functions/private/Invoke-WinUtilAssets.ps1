function Invoke-WinUtilAssets {
  param (
      $type,
      $Size,
      [switch]$render
  )

  if ($render -and $null -ne $sync) {
      if ($null -eq $sync.RenderedAssetCache) {
          $sync.RenderedAssetCache = @{}
      }

      $cacheKey = "$(([string]$type).ToLowerInvariant())|$Size"
      if ($sync.RenderedAssetCache.ContainsKey($cacheKey)) {
          return $sync.RenderedAssetCache[$cacheKey]
      }
  }

  # Create the Viewbox and set its size
  $LogoViewbox = New-Object Windows.Controls.Viewbox
  $LogoViewbox.Width = $Size
  $LogoViewbox.Height = $Size

  # Create a Canvas to hold the paths
  $canvas = New-Object Windows.Controls.Canvas
  $canvas.Width = 100
  $canvas.Height = 100

  # Define a scale factor for the content inside the Canvas
  $scaleFactor = $Size / 100

  # Apply a scale transform to the Canvas content
  $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
  $canvas.LayoutTransform = $scaleTransform

  switch ($type) {
      'logo' {
          # Letter C
          $CPathData = @"
M 28,15 Q 22,20 22,32 Q 22,44 28,49 Q 34,52 40,49 L 40,46 Q 36,48 32,48 Q 27,46 27,32 Q 27,18 32,16 Q 36,14 40,16 L 40,13 Q 34,10 28,15 Z
"@
          $CPath = New-Object Windows.Shapes.Path
          $CPath.Data = [Windows.Media.Geometry]::Parse($CPathData)
          $CPath.Fill = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $CPath.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $CPath.StrokeThickness = 0

          # Underscore
          $UnderscorePathData = @"
M 42,50 L 48,50
"@
          $UnderscorePath = New-Object Windows.Shapes.Path
          $UnderscorePath.Data = [Windows.Media.Geometry]::Parse($UnderscorePathData)
          $UnderscorePath.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $UnderscorePath.StrokeThickness = 1.8

          # Hash symbol (#) - vertical left
          $HashVertLeft = New-Object Windows.Shapes.Line
          $HashVertLeft.X1 = 50
          $HashVertLeft.Y1 = 8
          $HashVertLeft.X2 = 50
          $HashVertLeft.Y2 = 52
          $HashVertLeft.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $HashVertLeft.StrokeThickness = 1.8

          # Hash symbol (#) - vertical right
          $HashVertRight = New-Object Windows.Shapes.Line
          $HashVertRight.X1 = 60
          $HashVertRight.Y1 = 8
          $HashVertRight.X2 = 60
          $HashVertRight.Y2 = 52
          $HashVertRight.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $HashVertRight.StrokeThickness = 1.8

          # Hash symbol (#) - horizontal top
          $HashHorizTop = New-Object Windows.Shapes.Line
          $HashHorizTop.X1 = 46
          $HashHorizTop.Y1 = 22
          $HashHorizTop.X2 = 64
          $HashHorizTop.Y2 = 22
          $HashHorizTop.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $HashHorizTop.StrokeThickness = 1.8

          # Hash symbol (#) - horizontal bottom
          $HashHorizBottom = New-Object Windows.Shapes.Line
          $HashHorizBottom.X1 = 46
          $HashHorizBottom.Y1 = 38
          $HashHorizBottom.X2 = 64
          $HashHorizBottom.Y2 = 38
          $HashHorizBottom.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $HashHorizBottom.StrokeThickness = 1.8

          # Head profile silhouette (side view)
          $HeadProfilePathData = @"
M 35,65 Q 32,62 32,58 Q 32,54 35,52 L 38,50 Q 40,48 42,48 Q 45,48 47,50 Q 50,52 52,55 L 54,60 Q 55,64 53,68 Q 50,72 46,74 Q 42,75 38,74 Q 35,72 35,68 Z
"@
          $HeadProfilePath = New-Object Windows.Shapes.Path
          $HeadProfilePath.Data = [Windows.Media.Geometry]::Parse($HeadProfilePathData)
          $HeadProfilePath.Fill = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))

          # Hair (styled back)
          $HairPathData = @"
M 38,50 Q 36,48 38,45 Q 40,43 43,44 Q 46,44 48,46
"@
          $HairPath = New-Object Windows.Shapes.Path
          $HairPath.Data = [Windows.Media.Geometry]::Parse($HairPathData)
          $HairPath.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $HairPath.StrokeThickness = 1.2
          $HairPath.Fill = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))

          # Ear
          $EarPathData = @"
M 54,58 Q 57,60 57,65 Q 57,68 55,70
"@
          $EarPath = New-Object Windows.Shapes.Path
          $EarPath.Data = [Windows.Media.Geometry]::Parse($EarPathData)
          $EarPath.Stroke = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))
          $EarPath.StrokeThickness = 1

          # Neck
          $NeckPathData = @"
M 42,74 L 42,80 L 46,80 L 46,74
"@
          $NeckPath = New-Object Windows.Shapes.Path
          $NeckPath.Data = [Windows.Media.Geometry]::Parse($NeckPathData)
          $NeckPath.Fill = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))

          # Shoulder/jacket
          $ShoulderPathData = @"
M 38,76 L 32,85 L 32,95 L 52,95 L 52,85 L 48,76
"@
          $ShoulderPath = New-Object Windows.Shapes.Path
          $ShoulderPath.Data = [Windows.Media.Geometry]::Parse($ShoulderPathData)
          $ShoulderPath.Fill = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromArgb(255, 0, 0, 0))

          $canvas.Children.Add($CPath) | Out-Null
          $canvas.Children.Add($UnderscorePath) | Out-Null
          $canvas.Children.Add($HashVertLeft) | Out-Null
          $canvas.Children.Add($HashVertRight) | Out-Null
          $canvas.Children.Add($HashHorizTop) | Out-Null
          $canvas.Children.Add($HashHorizBottom) | Out-Null
          $canvas.Children.Add($HeadProfilePath) | Out-Null
          $canvas.Children.Add($HairPath) | Out-Null
          $canvas.Children.Add($EarPath) | Out-Null
          $canvas.Children.Add($NeckPath) | Out-Null
          $canvas.Children.Add($ShoulderPath) | Out-Null
      }
      'checkmark' {
          $canvas.Width = 512
          $canvas.Height = 512

          $scaleFactor = $Size / 2.54
          $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
          $canvas.LayoutTransform = $scaleTransform

          # Define the circle path
          $circlePathData = "M 1.27,0 A 1.27,1.27 0 1,0 1.27,2.54 A 1.27,1.27 0 1,0 1.27,0"
          $circlePath = New-Object Windows.Shapes.Path
          $circlePath.Data = [Windows.Media.Geometry]::Parse($circlePathData)
          $circlePath.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#39ba00")

          # Define the checkmark path
          $checkmarkPathData = "M 0.873 1.89 L 0.41 1.391 A 0.17 0.17 0 0 1 0.418 1.151 A 0.17 0.17 0 0 1 0.658 1.16 L 1.016 1.543 L 1.583 1.013 A 0.17 0.17 0 0 1 1.599 1 L 1.865 0.751 A 0.17 0.17 0 0 1 2.105 0.759 A 0.17 0.17 0 0 1 2.097 0.999 L 1.282 1.759 L 0.999 2.022 L 0.874 1.888 Z"
          $checkmarkPath = New-Object Windows.Shapes.Path
          $checkmarkPath.Data = [Windows.Media.Geometry]::Parse($checkmarkPathData)
          $checkmarkPath.Fill = [Windows.Media.Brushes]::White

          # Add the paths to the Canvas
          $canvas.Children.Add($circlePath) | Out-Null
          $canvas.Children.Add($checkmarkPath) | Out-Null
      }
      'warning' {
          $canvas.Width = 512
          $canvas.Height = 512

          # Define a scale factor for the content inside the Canvas
          $scaleFactor = $Size / 512  # Adjust scaling based on the canvas size
          $scaleTransform = New-Object Windows.Media.ScaleTransform($scaleFactor, $scaleFactor)
          $canvas.LayoutTransform = $scaleTransform

          # Define the circle path
          $circlePathData = "M 256,0 A 256,256 0 1,0 256,512 A 256,256 0 1,0 256,0"
          $circlePath = New-Object Windows.Shapes.Path
          $circlePath.Data = [Windows.Media.Geometry]::Parse($circlePathData)
          $circlePath.Fill = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#f41b43")

          # Define the exclamation mark path
          $exclamationPathData = "M 256 307.2 A 35.89 35.89 0 0 1 220.14 272.74 L 215.41 153.3 A 35.89 35.89 0 0 1 251.27 116 H 260.73 A 35.89 35.89 0 0 1 296.59 153.3 L 291.86 272.74 A 35.89 35.89 0 0 1 256 307.2 Z"
          $exclamationPath = New-Object Windows.Shapes.Path
          $exclamationPath.Data = [Windows.Media.Geometry]::Parse($exclamationPathData)
          $exclamationPath.Fill = [Windows.Media.Brushes]::White

          # Get the bounds of the exclamation mark path
          $exclamationBounds = $exclamationPath.Data.Bounds

          # Calculate the center position for the exclamation mark path
          $exclamationCenterX = ($canvas.Width - $exclamationBounds.Width) / 2 - $exclamationBounds.X
          $exclamationPath.SetValue([Windows.Controls.Canvas]::LeftProperty, $exclamationCenterX)

          # Define the rounded rectangle at the bottom (dot of exclamation mark)
          $roundedRectangle = New-Object Windows.Shapes.Rectangle
          $roundedRectangle.Width = 80
          $roundedRectangle.Height = 80
          $roundedRectangle.RadiusX = 30
          $roundedRectangle.RadiusY = 30
          $roundedRectangle.Fill = [Windows.Media.Brushes]::White

          # Calculate the center position for the rounded rectangle
          $centerX = ($canvas.Width - $roundedRectangle.Width) / 2
          $roundedRectangle.SetValue([Windows.Controls.Canvas]::LeftProperty, $centerX)
          $roundedRectangle.SetValue([Windows.Controls.Canvas]::TopProperty, 324.34)

          # Add the paths to the Canvas
          $canvas.Children.Add($circlePath) | Out-Null
          $canvas.Children.Add($exclamationPath) | Out-Null
          $canvas.Children.Add($roundedRectangle) | Out-Null
      }
      default {
          Write-Host "Invalid type: $type"
      }
  }

  # Add the Canvas to the Viewbox
  $LogoViewbox.Child = $canvas

  if ($render) {
      # Measure and arrange the canvas to ensure proper rendering
      $canvas.Measure([Windows.Size]::new($canvas.Width, $canvas.Height))
      $canvas.Arrange([Windows.Rect]::new(0, 0, $canvas.Width, $canvas.Height))
      $canvas.UpdateLayout()

      # Initialize RenderTargetBitmap correctly with dimensions
      $renderTargetBitmap = New-Object Windows.Media.Imaging.RenderTargetBitmap($canvas.Width, $canvas.Height, 96, 96, [Windows.Media.PixelFormats]::Pbgra32)

      # Render the canvas to the bitmap
      $renderTargetBitmap.Render($canvas)

      # Create a BitmapFrame from the RenderTargetBitmap
      $bitmapFrame = [Windows.Media.Imaging.BitmapFrame]::Create($renderTargetBitmap)

      # Create a PngBitmapEncoder and add the frame
      $bitmapEncoder = [Windows.Media.Imaging.PngBitmapEncoder]::new()
      $bitmapEncoder.Frames.Add($bitmapFrame)

      # Save to a memory stream
      $imageStream = New-Object System.IO.MemoryStream
      $bitmapEncoder.Save($imageStream)
      $imageStream.Position = 0

      # Load the stream into a BitmapImage
      $bitmapImage = [Windows.Media.Imaging.BitmapImage]::new()
      $bitmapImage.BeginInit()
      $bitmapImage.StreamSource = $imageStream
      $bitmapImage.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
      $bitmapImage.EndInit()
      if ($bitmapImage.CanFreeze) {
          $bitmapImage.Freeze()
      }

      if ($null -ne $sync -and $sync.ContainsKey("RenderedAssetCache")) {
          $sync.RenderedAssetCache[$cacheKey] = $bitmapImage
      }

      return $bitmapImage
  } else {
      return $LogoViewbox
  }
}
