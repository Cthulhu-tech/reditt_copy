import { validate } from "../../utils/validator";
import { useFetch } from "../../hook/useFetch";
import { useForm } from "../../hook/useForm";
import { useEffect } from "react";

export const Registration = () => {

    const responseData = () => {

        FetchData('/registration', dataForm)

    }

    const {load, data, errorResponse, FetchData} = useFetch();
    const {handleInput, handleSubmit, dataForm, error} = useForm(responseData, validate);

    useEffect(() => {}, [error])

    return <form onSubmit={handleSubmit}>
        <input type="text" name="login" placeholder="login"
            onChange={handleInput}
        />
        {error?.login && <p>{error.login}</p>}
        <input type="text" name="mail" placeholder="mail"
            onChange={handleInput}
        />
        {error?.mail && <p>{error.mail}</p>}
        <input type="text" name="password" placeholder="password"
            onChange={handleInput}
        />
        {error?.password && <p>{error.password}</p>}
        <input type="text" name="repeat_password" placeholder="repeat password"
            onChange={handleInput}
        />
        {error?.repeat_password && <p>{error.repeat_password}</p>}
        <button type="submit">login</button>
    </form>

}