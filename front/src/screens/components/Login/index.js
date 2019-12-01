import React, { useState } from "react" 
import Button from "../../../components/Button"
import Label from "../../../components/Label"

const Login = ({ login, loading }) => {
    const [username, setUsername] = useState()
    const [password, setPassword] = useState()

    const autheticate = () => {
        login(username, password)
    }

    return (
        <div>
            <div>
                <Label>Usuário: </Label>
                <input type="text" onChange={(input) => { setUsername(input.target.value) }}></input>
            </div>
            <div>
                <Label>Senha: </Label>
                <input type="password" onChange={(input) => { setPassword(input.target.value) }}></input>
            </div>
            {
                loading
                    ? <Label>Carregando</Label>
                    : <Button title="Login" click={autheticate}></Button>
            }
            
        </div>
    )
}

export default Login