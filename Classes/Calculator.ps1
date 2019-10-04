Class Calculator
{
  hidden [double]$_operand = 0
  hidden [string]$_historyFile
  # Global result history
  static $history = @()

  Calculator([int]$operand)
  {
    $this._historyFile = "$env:TEMP\PsCalculatorHistory.txt"

    # Need a temporary variable, as we cannot reference to class variable by [ref]$this.variable
    $tmpValue = 0
    [double]::TryParse($operand, [ref]$tmpValue)
    $this._operand = $tmpValue

    $this._InitHistory()
  }

  Calculator([int]$operand, [string]$historyFile)
  {
    if (Test-Path $historyFile) {
      $this._historyFile = $historyFile
    }
    else {
      $this._historyFile = "$env:TEMP\PsCalculatorHistory.txt"      
    }
    
    # Need a temporary variable, as we cannot reference to class variable by [ref]$this.variable
    $tmpValue = 0
    [double]::TryParse($operand, [ref]$tmpValue)
    $this._operand = $tmpValue

    $this._InitHistory()
  }

  [double]Add([int]$operand)
  {
    $result = $this._operand + $operand

    Write-Host "Adding $($this._operand) and $($operand)"

    $this._WriteHistory($result)
    return $result
  }

  [double]Substract([int]$operand)
  {
    $result = $this._operand - $operand

    Write-Host "Substracting $($this._operand) by $($operand)"

    $this._WriteHistory($result)
    return $result
  }

  [double]Devide([int]$operand)
  {
    $result = $this._operand / $operand

    Write-Host "Deviding $($this._operand) by $($operand)"
    
    $this._WriteHistory($result)
    return $result
  }

  [double]Multiply([int]$operand)
  {
    $result = $this._operand * $operand

    Write-Host "Multiplying $($this._operand) by $($operand)"

    $this._WriteHistory($result)
    return $result
  }

  [double]Modulus([int]$operand)
  {
    $result = $this._operand % $operand

    Write-Host "Modulus of $($this._operand) % $($operand)"

    $this._WriteHistory($result)
    return $result
  }
  
  [boolean]IsEven([int]$value)
  {
    return ($value % 2 -eq 0)
  }

  [void]_WriteHistory([int]$entry)
  {
    [Calculator]::history += $entry
    Out-File -FilePath $this._historyFile -Append -InputObject $entry -Force
  }

  [void]_InitHistory()
  {
    Out-File -FilePath $this._historyFile -Append -InputObject ([DateTime]::UtcNow) -Force
    foreach ($entry in Get-Content -Path $this._historyFile) {
      [Calculator]::history += $entry
    }
  }
}