Class Calculator
{
  [double]$operand = 0
  static $history = @()

  Calculator([int]$operand)
  {
    $this.operand = $operand
  }

  Calculator() {}

  [void]Add([int]$operand)
  {
    $message = "Increasing $($this.operand) by $($operand)"
    $this.operand = $this.operand + $operand
    $this._WriteHistory($message)
  }

  [void]Substract([int]$operand)
  {
    $message = "Substracting $($this.operand) by $($operand)"
    $this.operand = $this.operand - $operand
    $this._WriteHistory($message)
  }

  [void]Devide([int]$operand)
  {
    $message = "Deviding $($this.operand) by $($operand)"
    $this.operand = $this.operand / $operand
    $this._WriteHistory($message)
  }

  [void]Multiply([int]$operand)
  {
    $message = "Multiplying $($this.operand) by $($operand)"
    $this.operand = $this.operand * $operand
    $this._WriteHistory($message)
  }

  hidden [void]_WriteHistory($entry)
  {
    $entry = "$entry : $($this.operand)"
    Write-Host $entry
    [Calculator]::history += $entry
  }

  [boolean]IsEven()
  {
    return ($this.operand % 2 -eq 0)
  }
}