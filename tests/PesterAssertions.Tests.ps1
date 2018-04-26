. "$PSScriptRoot/../internal/functions/PesterAssertions.ps1"

Describe "Testing custom pester assertions" {
    Context "Testing passing assertion" { 
        
        It "Should pass when there is no error thrown" {
            { } | Should -Pass 
        }

        It "Should fail when an exception is thrown" {
            $failed = $false 
            try {
                { throw } | Should -Pass 
            } catch {
                $failed = $true 
            }
            $failed | Should -BeTrue
        }

        It "Should pass when test failes but -Not is specified" {
            { throw } | Should -Not -Pass 
        }

        It "Should fail when test passes but -Not is specified" {
            $failed = $false 
            try {
                { } | Should -Not -Pass 
            } catch {
                $failed = $true 
            }
            $failed | Should -BeTrue
        }
    }

    Context "Testing inconclusive assertion" {
        It "Should pass when test is inconclusive" {
            { Set-TestInconclusive } | Should -BeInconclusive 
        }

        It "Should fail when test is not inconclusive" {
            $failed = $false 
            try {
                { } | Should -BeInconclusive
            } catch { 
                $failed = $true 
            }
            $failed | Should -BeTrue
        }

        It "Should pass when test failes but -Not is specified" {
            { } | Should -Not -BeInconclusive
        }

        It "Should fail when test is inconclusive but -Not is specified" {
            $failed = $false 
            try {
                { Set-TestInconclusive } | Should -Not -BeInconclusive
            } catch { 
                $failed = $true 
            }
            $failed | Should -BeTrue
        }
    }

    Context "Testing failing assertion" {
        It "Should pass when test fails" {
            { $false | Should -BeTrue } | Should -Fail
        }

        It "Should fail when test passes" {
            $failed = $false 
            try {
                { $true | Should -BeTrue } | Should -Fail
            } catch { 
                $failed = $true 
            }
            $failed | Should -BeTrue
        }

        It "Should pass when test passes but -Not is specified" {
            { $true | Should -BeTrue } | Should -Not -Fail
        }

        It "Should fail when test is fails but -Not is specified" {
            $failed = $false 
            try {
                { $false | Should -BeTrue } | Should -Not -Fail
            } catch { 
                $failed = $true 
            }
            $failed | Should -BeTrue
        }
    }
}