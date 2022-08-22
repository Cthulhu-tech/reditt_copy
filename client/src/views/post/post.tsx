import { useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { useFetch } from '../../hook/useFetch';
export const Post = () => {

    const {id} = useParams();
    const {load, data, errorResponse, FetchData} = useFetch('GET');

    useEffect(() => {

        FetchData("/post/" + id)

    },[])


    useEffect(() => {},[load, data, errorResponse])

    return <section>
        
    </section>

}