Class AdvancedPing
{
    hidden [string]$_packets
    hidden [string]$_duration
    hidden [string]$_hostName
    hidden [string]$_ip
    hidden [int]$_bytes = 64
    hidden [int]$_ttl = 57
    hidden [int]$_timeout = 120
    hidden [int]$_interval = 1000
    hidden [int]$_counter = 0
    hidden [int]$_success
    hidden [bool]$_dontFragment = $false
    hidden [bool]$_timestamp

    AdvancedPing([string]$target, [string]$packets, [string]$duration)
	{
        $this._packets = $packets
        $this._duration = $duration

        # Adding getter and setter

        $properties = "timestamp", "ttl", "timeout", "bytes", "duration", "interval"
        foreach($property in $properties)
        {
            $this._AddProperty($property)
        }

        # Checking if target is DNS or IP address and resolve DNS name

        $this._SetTarget($target)
    }
    
    Ping()
    {
        $this._counter = 0
        
        $startMessage = "PING {0} ({1}) {2} bytes of data." -f $this._hostname, $this._ip, $this._bytes

        [System.Console]::WriteLine($startMessage)

        # Create Ping and Ping Options instances
        $pinger = [System.Net.NetworkInformation.Ping]::new()
        $pingOptions = [System.Net.NetworkInformation.PingOptions]::new($this._ttl, $this._dontFragment)

        # Initialize buffer
        [byte[]]$buffer = [byte[]]::new($this._bytes);

        Write-Verbose "Starting stopwatch"

        $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
        while (($stopwatch.Elapsed.TotalMilliseconds -lt $this._duration) -and ($this._counter -lt $this._packets))
        {
            $this._counter += 1
            $this._SendPing($pinger, $pingOptions, $buffer)
            Start-Sleep -Milliseconds $this._interval
        }

        Write-Verbose "Finishing up"
        $stopwatch.Stop()
        [System.Console]::WriteLine("--- $($this._ip) ping statistics ---")
        $statistics = '{0} packets transmitted, {1} received, {2}% packet loss, time {3}ms' -f $this._counter, $this._success, (100 - ($this._success*100/$this._counter)), ($stopwatch.ElapsedMilliseconds)
        [System.Console]::WriteLine($statistics)
    }

    hidden _SendPing([object]$pinger, [object]$pingOptions, [object]$buffer)
    {
        $reply = $pinger.send($this._ip, $this._timeout, $buffer, $pingOptions)

        if ($reply.Status -eq "Success")
        {
            $this._success += 1
            if ($this._timestamp)
            {
                $message = "[{0}] {1} bytes from {2}: icmp_seq={3} ttl={4} time={5} ms" -f [datetime]::Now, $this._bytes, $this._ip, $this._counter, $this._ttl, $reply.RoundtripTime
            }
            else 
            {
                $message = "{0} bytes from {1}: icmp_seq={2} ttl={3} time={4} ms" -f $this._bytes, $this._ip, $this._counter, $this._ttl, $reply.RoundtripTime
            }
            [System.Console]::WriteLine($message)
        }
        elseif ($reply.Status -eq "TimedOut") 
        {
            [System.Console]::WriteLine("Request timed out")
        }
    }

    hidden _SetTarget([string]$target)
    {
        
        $out = [System.Net.ipaddress]::None

        if ([System.Net.ipaddress]::TryParse($target, [ref]$out))
        {
            $this._ip = $target
            $this._hostname = $target
        }
        else 
        {
            try 
            {
                $resolvedName = [System.Net.Dns]::GetHostEntry($target)
                $this._ip = $resolvedName.AddressList[0]
                $this._hostname = $target
            }
            catch
            {
                $msg = $_.Exception.Message
                If ($msg -like "*No such host is known*") 
                {
                    $msg = 'Cannot resolve DNS name {0}' -f $target
                }
                Write-Error $msg
            }
        }
    }

    hidden _AddProperty([string]$propName)
    {
        $property = new-object management.automation.PsScriptProperty $propName, {$propname = $propname; return $this."_$propName"}.GetNewClosure(), {param($value) $propname = $propname; $this."_$propName" = $value}.GetNewClosure()
        $this.psobject.properties.add($property)
    }
}