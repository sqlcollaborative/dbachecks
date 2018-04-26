function FailingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $false
    try {
        & $ActualValue
    } catch {
        $psitem.FullyQualifiedErrorID -eq "PesterAssertionFailed"
        $Pass = $true 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should not fail.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should fail but it passed.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

function InconclusiveTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $false
    try {
        & $ActualValue
    } catch {
        $psitem.FullyQualifiedErrorID -eq "PesterTestSkipped"
        $Pass = $true
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should not be inconclusive.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should be inconclusive.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

function PassingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $true
    try {
        & $ActualValue
    } catch {
        $Pass = $false 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should fail but it passed.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should pass.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

function SkippingTestAssertion {
    [CmdletBinding()]
    Param(
        [ScriptBlock]$ActualValue,
        [switch]$Negate
    )

    [bool]$Pass = $false
    try {
        & $ActualValue
    } catch {
        $psitem.FullyQualifiedErrorID -eq "PesterTestSkipped"
        $Pass = $true 
    }

    If ( $Negate ) { $Pass = -not($Pass) }

    If ( -not($Pass) ) {
        If ( $Negate ) {
            $FailureMessage = 'Expected: test {{{0}}} should not skip.' -f $ActualValue
        }
        Else {
            $FailureMessage = 'Expected: test {{{0}}} should skip.' -f $ActualValue
        }
    }

    $ObjProperties = @{
        Succeeded      = $Pass
        FailureMessage = $FailureMessage
    }
    return New-Object PSObject -Property $ObjProperties
}

try {
    Add-AssertionOperator -Name 'Fail' -Test $Function:FailingTestAssertion
    Add-AssertionOperator -Name 'BeInconclusive' -Test $Function:InconclusiveTestAssertion
    Add-AssertionOperator -Name 'Pass' -Test $Function:PassingTestAssertion
    Add-AssertionOperator -Name 'Skip' -Test $Function:SkippingTestAssertion
} catch {}