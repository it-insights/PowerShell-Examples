Class Calculator
{
  [double]$operand

  Calculator([int]$operand)
  {
    $this.operand = $operand
  }

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