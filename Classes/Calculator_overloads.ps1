Class Calculator
{
  hidden [double]$operand = 0

  Calculator([int]$operand)
  {
    $tmpValue = 0
    [double]::TryParse($operand, [ref]$tmpValue)
    $this._operand = $tmpValue
  }

  Calculator() {}

  [double]Add([int]$operand)
  {
    Write-Host "Increasing $($this.operand) by $($operand)"
    $this.operand = $this.operand + $operand
    return $this.operand
  }

  [double]Substract([int]$operand)
  {
    Write-Host "Substracting $($this.operand) by $($operand)"
    $this.operand = $this.operand - $operand
    return $this.operand
  }

  [double]Devide([int]$operand)
  {
    Write-Host "Deviding $($this.operand) by $($operand)"
    $this.operand = $this.operand / $operand
    return $this.operand
  }

  [double]Multiply([int]$operand)
  {
    Write-Host "Multiplying $($this.operand) by $($operand)"
    $this.operand = $this.operand * $operand
    return $this.operand
  }

  [boolean]IsEven()
  {
    return ($this.operand % 2 -eq 0)
  }
}