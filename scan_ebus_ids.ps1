param (
    [string]$filePathDecoded
)

$firstBlockValue = $null
$dictionary = @{}

Get-Content $filePathDecoded | ForEach-Object {
    if ($_ -match '^[0-9a-fA-F]+ / [0-9a-fA-F]{16}') {
        $firstBlockValue = $_.Substring(0, $_.IndexOf(" / ")).Substring($_.IndexOf(" / ") - 8)
    } elseif ($firstBlockValue -ne $null -and $_ -match '^\s*TEM_P [0-9a-fA-F]+=') {
        $secondBlockValue = $_.Split('=')[1].Split(' ')[0] # get the value after the first equals sign and before the first space
        $secondBlockValue = $secondBlockValue.TrimEnd(',') # remove trailing comma

        if ($dictionary.ContainsKey($secondBlockValue)) {
            $dictionary[$secondBlockValue].Add($firstBlockValue) | Out-Null
        } else {
            $dictionary[$secondBlockValue] = New-Object System.Collections.Generic.HashSet[string]
            $dictionary[$secondBlockValue].Add($firstBlockValue) | Out-Null
        }

        $firstBlockValue = $null
    }
}

$dictionary.GetEnumerator() | Sort-Object Key | ForEach-Object {
    $sortedValues = [System.Collections.Generic.List[string]]($_.Value)
    $sortedValues.Sort()
    Write-Output "$($_.Key) -> $($sortedValues -join ',')"
}