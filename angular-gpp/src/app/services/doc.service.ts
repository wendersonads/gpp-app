import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { DocumentoFiscalModel } from '../models/DocumentoFiscalModel';


@Injectable({
  providedIn: 'root'
})
export class DocumentoFiscalService {


  public documentofiscals: DocumentoFiscalModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public post(doc: DocumentoFiscalModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/doc/`, doc);
  }

  public add(doc: DocumentoFiscalModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/doc/`, doc);
  }

  public get(idx: number): Observable<any>{
    return this.httpClient.get(`${environment.url}/doc/${idx}`);
    
  }

  public list(): Observable<any>{
    console.log(this.httpClient.get(`${environment.url}/doc/`))
    return this.httpClient.get(`${environment.url}/doc/`);
  }

  public delete(id: number): Observable<any>{
    return this.httpClient.delete(`${environment.url}/doc/${id}`);
  }

}
