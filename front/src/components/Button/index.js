import React from "react"
import "./index.css"

const Button = ({ title, click }) => {
    return (<input className="button" type="button" value={title} onClick={click}></input>)
}

export default Button