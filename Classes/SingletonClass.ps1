# Credits for explaining the concept to Michael Willis (@xainey)

class SingletonClass
{

    [string] $Parameter

    static [SingletonClass] $instance

    static [SingletonClass] GetInstance()
    {
        if ($null -eq [SingletonClass]::instance)
        {
            [SingletonClass]::instance = [SingletonClass]::new()
        }
        return [SingletonClass]::instance
    }
}